use std::sync::Arc;
use std::thread;
use std::time::Duration;

// NB: uniffi requires Send + Sync traits for anything exported
#[uniffi::export(with_foreign)]
pub trait ResultHandler: Send + Sync {
    fn error(&self, err: String);
    fn result(&self, s: String);
}

#[derive(uniffi::Object)]
pub struct Backend {
    rh: Arc<dyn ResultHandler>,
}

#[uniffi::export]
impl Backend {
    #[uniffi::constructor]
    fn new(rh: Arc<dyn ResultHandler>) -> Self {
        return Backend { rh: rh };
    }

    fn fetch_url(&self, url: String) {
        let rh = self.rh.clone();

        thread::spawn(move || {
            thread::sleep(Duration::from_millis(1000));

            let result = match ureq::get(&url).call() {
                Ok(result) => result,
                Err(error) => {
                    rh.error(error.to_string());
                    return;
                }
            };

            let body: String = result.into_string().unwrap();
            rh.result(body);
        });
    }
}

uniffi::setup_scaffolding!();
