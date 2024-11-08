use std::collections::HashMap;
use std::env;
use std::fs::File;
use std::io::Read;
use std::path::Path;
use std::process::Command;
use walkdir::WalkDir;
use md5::{Md5, Digest};

fn compute_dir_md5(dir: &str) -> Result<String, Box<dyn std::error::Error>> {
    let path = Path::new(dir);

    // Verifica che il percorso sia una directory esistente
    if !path.is_dir() {
        eprintln!("Errore: '{}' non è una directory valida o non esiste.", dir);
        return Err("Directory non valida".into());
    }

    // Colleziona tutti i file nella directory, ricorsivamente
    let mut file_paths = Vec::new();
    for entry in WalkDir::new(dir).into_iter().filter_map(|e| e.ok()) {
        if entry.file_type().is_file() {
            file_paths.push(entry.path().to_owned());
        }
    }

    // Ordina i percorsi dei file per garantire coerenza
    file_paths.sort();

    let mut md5_sums = Vec::new();

    // Calcola l'MD5 di ogni file
    for file_path in file_paths {
        let mut file = File::open(&file_path)?;
        let mut contents = Vec::new();
        file.read_to_end(&mut contents)?;

        let mut hasher = Md5::new();
        hasher.update(&contents);
        let result = hasher.finalize();

        md5_sums.push(format!("{:x}", result));
    }

    // Concatenazione di tutti gli MD5
    let concatenated_md5s = md5_sums.join("");

    // Calcola l'MD5 della concatenazione
    let mut final_hasher = Md5::new();
    final_hasher.update(concatenated_md5s.as_bytes());
    let final_result = final_hasher.finalize();
    let final_md5 = format!("{:x}", final_result);

    // Prende i primi 8 caratteri
    let md5_short = &final_md5[..8];

    Ok(md5_short.to_string())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Percorso del progetto host
    let host_project_path = env::current_dir()?;
    let host_project_path_str = host_project_path.to_str().ok_or("Percorso non valido")?;

    // Mappa delle directory e delle rispettive variabili d'ambiente
    let dir_env_map = HashMap::from([
        ("MD5_MAKE", "./dev/docker/make"),
        ("MD5_NODEJS", "./dev/docker/nodejs"),
        ("MD5_POSTGRES", "./dev/docker/postgres"),
    ]);

    // HashMap per conservare le variabili d'ambiente da passare al comando Docker
    let mut env_vars = HashMap::new();

    // Calcola gli MD5 e prepara le variabili d'ambiente
    for (env_var, dir_path) in &dir_env_map {
        let md5_value = compute_dir_md5(dir_path)?;
        env_vars.insert(env_var.to_string(), md5_value);
    }

    // Aggiungi HOST_PROJECT_PATH alle variabili d'ambiente
    env_vars.insert(
        "HOST_PROJECT_PATH".to_string(),
        host_project_path_str.to_string(),
    );

    // Prepara il comando Docker
    let mut command = Command::new("docker");
    command.args(&["compose", "run", "--rm", "--no-deps"]);

    // Mapping dei volumi (adattato per compatibilità cross-platform)
    if cfg!(target_os = "windows") {
        // Su Windows, il socket Docker si gestisce diversamente o si omette
    } else {
        command.args(&["-v", "/var/run/docker.sock:/var/run/docker.sock"]);
    }

    // Imposta le variabili d'ambiente nell'ambiente del processo
    for (key, value) in &env_vars {
        command.env(key, value);
    }

    // Passa a Docker solo i nomi delle variabili d'ambiente
    for key in env_vars.keys() {
        command.args(&["-e", key]);
    }

    // Specifica il servizio e il comando da eseguire
    command.args(&["make", "make"]);

    // Aggiunge eventuali argomenti aggiuntivi passati al programma
    let args: Vec<String> = env::args().skip(1).collect();
    command.args(&args);

    // Esegue il comando Docker
    let status = command.status()?;

    if !status.success() {
        eprintln!("Il comando Docker non è riuscito");
        std::process::exit(1);
    }

    Ok(())
}
