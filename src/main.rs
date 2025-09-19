use axum::Router;
use tower_http::services::ServeDir;

#[tokio::main]
async fn main() {
    let static_files = ServeDir::new("./target/dx/Ui/debug/web/public")
    .append_index_html_on_directories(true);

    let app = Router::new().fallback_service(static_files);
    let listener = tokio::net::TcpListener::bind("127.0.0.1:8080")
    .await
    .unwrap();
    axum::serve(listener, app).await.unwrap();
}

// use sqlx::postgres::PgPoolOptions;
// let db_name = std::env::var("DBNAME").expect("no catalog provided");
// let pool = PgPoolOptions::new()
//     .max_connections(10)
//     .connect(&format!("postgresql://localhost/{}", db_name))
//     .await
//     .unwrap();
