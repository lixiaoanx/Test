class AddMissingArrayFunction < ActiveRecord::Migration[6.0]
  def change
    execute(<<~SQL)
      CREATE OR REPLACE FUNCTION array_position(arr anyarray, elem anyelement, pos integer DEFAULT 1)
        RETURNS integer
        LANGUAGE sql
      AS $function$
      select row_number::INTEGER
      from (
        select unnest, row_number() over ()
        from ( select unnest(arr) ) t0
      ) t1
      where row_number >= greatest(1, pos)
        and (case when elem is null then unnest is null else unnest = elem end)
      limit 1;
      $function$
    SQL
  rescue
    puts $!
  end
end
