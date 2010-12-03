def load_parse_data
  {
    'name'        => 'mock',
    'plural'      => true,
    'auto'        => false,
    'indexes'     => {:default => [0]},
    'primaries'   => ["id", "power"],
    'fields'      => ["id", "name", "power"],
    'types'       => ["integer", "string, 20", "string, 40, Wuss"],
    'data'        => [[1, "Brian Jones", "Super Intelligence"], [2, "Superman", "Invincible"], [3, "Batman", "Strength"]],
    'ignore_cols' => [2],
    'connection'  => {'database' => 'moon', 'dbname' => 'db1'}
  }
end

def load_opts
  { :env => 'development' }
end
