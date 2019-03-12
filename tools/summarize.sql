.headers on
.output summary
select zoom_level, max(tile_row),min(tile_row),max(tile_column),min(tile_column), count(zoom_level) from map where zoom_level > 9 group by zoom_level;

