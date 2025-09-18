use actix_files::Files;
use actix_web::{App, HttpServer };
// use sqlx::postgres::PgPoolOptions;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenvy::dotenv().ok();
    // let db_name = std::env::var("DBNAME").expect("no catalog provided");
    // let pool = PgPoolOptions::new()
    //     .max_connections(10)
    //     .connect(&format!("postgresql://localhost/{}", db_name))
    //     .await
    //     .unwrap();

    HttpServer::new( || {
        App::new()
        .service(Files::new("/", "./target/dx/Ui/debug/web/public").index_file("index.html"))
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
