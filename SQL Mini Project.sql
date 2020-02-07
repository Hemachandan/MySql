use ipl;
#1
select bp.bidder_id,bd.bid_status, bp.no_of_bids,bp.total_points,sum(bd.bid_status='won'),(sum(bd.bid_status='Won')/bp.no_of_bids)*100 as'percentage_of_wins'
from ipl_bidding_details bd natural join ipl_bidder_points bp group by bidder_id order by percentage_of_wins desc;

#2
select bd.*,count(bd.bid_team) as 'number_of_bids' from ipl_bidding_details bd inner join ipl_team t on t.team_id=bd.bid_team group by t.team_id order by number_of_bids desc;

#3\
-- create view jai as
select s.*,s.stadium_name,s.stadium_id,count(m.toss_winner) as ab
from ipl_stadium s inner join ipl_match_schedule ms
on s.stadium_id=ms.stadium_id
inner join ipl_match m
on m.match_id=ms.match_id
where m.toss_winner=m.match_winner
group by stadium_name;
select jai.stadium_name,jai.stadium_id,count(ms.stadium_id),(ab/count(ms.stadium_id))*100 as '% win in a stadium when a team won the toss'
from jai inner join ipl_match_schedule ms
on jai.stadium_id=ms.stadium_id
group by jai.stadium_name;

#4
create view abc as
select *,
case
when  match_winner =1 then team_id1
when match_winner=2 then team_id2
end as 'team_who_won'
from ipl_match;
select *, count(team_who_won) from abc
group by team_who_won;
select *, count(bid_team) from ipl_bidding_details
group by bid_team
having bid_team=6;

#5
select * from ipl_team_standings;
create view points_in_2017 as
select tournmt_id,total_points,team_id 
from ipl_team_standings
where tournmt_id=2017;
create view points_in_2018 as
select tournmt_id,total_points,team_id 
from ipl_team_standings
where tournmt_id=2018;
select a.team_id,((b.total_points-a.total_points)/a.total_points)*100
from points_in_2017 a inner join points_in_2018 b
on a.team_id=b.team_id;