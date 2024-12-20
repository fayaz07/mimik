use diesel::prelude::*;
use dotenvy::dotenv;
use std::env;

let mut db: SqliteConnection;

pub fn init_db() {
    dotenv().ok();

    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    db = SqliteConnection::establish(&database_url)
        .unwrap_or_else(|_| panic!("Error connecting to {}", database_url));
}
