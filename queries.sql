-- Goal schema
CREATE TABLE goal (
	goal serial NOT NULL,
	goal_name varchar(60) NOT NULL,
	unit varchar(60) NULL,
	active bool NULL DEFAULT true,
	CONSTRAINT goal_pkey PRIMARY KEY (goal)
);

-- Progress Schema
CREATE TABLE progress (
	progress int4 serial not null,
	amount numeric(6,2) NOT NULL,
	session_date timestamp NOT NULL DEFAULT now(),
	goal int4 NOT NULL,
	CONSTRAINT progress_pkey PRIMARY KEY (progress)
    CONSTRAINT goal_tracker_goal_fkey FOREIGN KEY (goal) REFERENCES public.goal(goal);
);





-- Create record
insert into progress (goal, amount, session_date) 
values
(3, 25, '2021-02-04');


-- Update record
update progress 
se 
values
(3, 25, '2021-02-04');


-- Get all progress by type for year
select progress.*, goal.goal_name, goal.unit 
from progress
left join goal on progress.goal = goal.goal 
where progress.goal = 1
and session_date between '2021-01-01' and '2022-01-01'
order by session_date;


-- Get all goal options
select * from goal;


-- Get weights
select progress, session_date, amount as weight, progress.goal, goal.goal_name, goal.unit 
from progress
left join goal on goal.goal = progress.goal
where progress.goal = 2
and session_date between '2021-01-01' and '2022-01-01'
order by session_date;



-- Get pushups by day
select date_trunc('day', session_date) as pushup_day, sum(amount) as total_pushups, progress.goal, goal.goal_name, goal.unit
from progress
left join goal on goal.goal = progress.goal
where progress.goal = 1
and session_date between '2021-01-01' and '2022-01-01'
group by pushup_day, progress.goal, goal.goal_name, goal.unit 
order by pushup_day;


-- Get sessions with most pushups
select progress.*, goal.goal_name, goal.unit 
from progress
left join goal on goal.goal = progress.goal
where progress.goal = 1
and session_date between '2021-01-01' and '2022-01-01'
and amount = (
	select max(amount) 
	from progress 
	where goal = 1
	and session_date between '2021-01-01' and '2022-01-01'
)
order by session_date;


-- Get days with the most total pushups
select date_trunc('day', session_date) as pushup_day, sum(amount) as total_pushups, progress.goal, goal.goal_name, goal.unit
from progress
left join goal on goal.goal = progress.goal
where progress.goal = 1
and session_date between '2021-01-01' and '2022-01-01'
group by pushup_day, progress.goal, goal.goal_name, goal.unit 
having sum(amount) = (
	select max(grouped_sessions.total_amount)
	from(
		select sum(amount) as total_amount
		from progress
		where progress.goal = 1
		and session_date between '2021-01-01' and '2022-01-01'
		group by date_trunc('day', session_date), progress.goal
	) as grouped_sessions
)
order by pushup_day;


-- Get drawing by day
select date_trunc('day', session_date) as drawing_day, sum(amount) as drawing_minutes, progress.goal, goal.goal_name, goal.unit 
from progress
left join goal on goal.goal = progress.goal
where progress.goal = 3
and session_date between '2021-01-01' and '2022-01-01'
group by drawing_day, progress.goal, goal.goal_name, goal.unit
order by drawing_day;


-- Get sessions with longest time drawing
select progress.*, goal.goal_name, goal.unit 
from progress
left join goal on goal.goal = progress.goal
where progress.goal = 3
and session_date between '2021-01-01' and '2022-01-01'
and amount = (
	select max(amount) 
	from progress 
	where goal = 3
	and session_date between '2021-01-01' and '2022-01-01'
)
order by session_date;