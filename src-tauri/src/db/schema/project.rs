diesel::table! {
  projects (id) {
      id -> Integer,
      name -> Text,
      desc -> Text,
      created_on -> Timestamp,
  }
}
