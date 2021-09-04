const IDCOLUMN = 'id';
const NAMECOLUMN = 'name';
const EMAILCOLUMN = 'email';
const PHONECOLUMN = 'phone';
const IMAGECOLUMN = 'image';
const TABLENAME = 'contact';
const SQL = "CREATE TABLE $TABLENAME(" +
"$IDCOLUMN INTEGER PRIMARY KEY, " + 
"$NAMECOLUMN TEXT, " +
"$EMAILCOLUMN TEXT, " +
"$PHONECOLUMN TEXT, " +
"$IMAGECOLUMN TEXT)";