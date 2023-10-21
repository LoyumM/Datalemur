select distinct(year_rank) as year_rank, group_name, song_name
from billboard_top_100_year_end
where year = 2010
    and year_rank <= 10
order by year_rank;