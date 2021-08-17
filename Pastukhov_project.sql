--удаление всех таблиц
drop table FACT_OPER;
drop table PLAN_OPER;
drop table PR_CRED;
drop table CLIENT;

--создание таблицы "Клиенты"
    create table CLIENT    ( 
    ID          number(25),	
    CONSTRAINT  client_id_pk   PRIMARY KEY (ID), 
    CL_NAME		varchar2(100), 
    DATE_BIRTH	date
    ) ;
    
    --создание таблицы "Кредитные договоры"
    create table PR_CRED    ( 
    ID			number(25),	
    CONSTRAINT  pr_cred_id_pk   PRIMARY KEY (ID), 
    NUM_DOG		varchar2(20), 
    SUMMA_DOG	number, 
    DATE_BEGIN	date, 
    DATE_END	date, 
    ID_CLIENT	number(25),	
    CONSTRAINT	pr_cred_id_client_fk   FOREIGN KEY (ID_CLIENT)
        REFERENCES CLIENT (ID), 
    COLLECT_PLAN number(25),
    CONSTRAINT pr_cred_col_plan_unique UNIQUE (COLLECT_PLAN), 
    COLLECT_FACT number(25),
    CONSTRAINT pr_cred_col_fact_unique UNIQUE (COLLECT_FACT)
	) ;
	
--создание таблицы "Плановые операции"
    create table PLAN_OPER ( 
    COLLECTION_ID	number(25),
    CONSTRAINT plan_oper_col_id_fk FOREIGN KEY (COLLECTION_ID) 
        references pr_cred (collect_plan), 
    P_DATE		date, 
    P_SUMMA		number, 
    TYPE_OPER	varchar2(40)
    ) ;

--создание таблицы "Фактические операции"	
    create table FACT_OPER    ( 
    COLLECTION_ID	number(25),
    CONSTRAINT fact_oper_col_id_fk FOREIGN KEY (collection_id) 
    REFERENCES pr_cred (collect_fact), 
    F_DATE		date, 
    F_SUMMA		number, 
    TYPE_OPER	varchar2(40)
    ) ;
	
drop function balance;
drop function calculate_of_percent;
drop view portfolio_condition;

--Создание функции "Остаток_ссудной_задолженности_на_дату"
create or replace function balance(
    client_id in number,
    number_dog in varchar2,
    given_date in date)
    return number
is
    result number := 0;
begin
    with sum_table as
    (select p.num_dog pn, sum(f.f_summa) sumf
    from fact_oper f, pr_cred p
    where f.collection_id = p.collect_fact
        and f.type_oper = 'Погашение кредита'
        and f.f_date <= to_date(given_date)
    group by p.num_dog)

    select f.f_summa - s.sumf into result
        from fact_oper f, pr_cred p, sum_table s
        where f.collection_id = p.collect_fact
            and p.num_dog = s.pn
            and f.type_oper = 'Выдача кредита'
            and f.f_date <= to_date(given_date)
            and p.id_client = client_id
            and p.num_dog = number_dog;
    return result;
exception
    when no_data_found then
    dbms_output.put_line('Нет данных!');   
end;
/

--Создание функции "Сумма_предстоящих_процентов_к_погашению"
create or replace function calculate_of_percent(
    client_id in number,
    number_dog in varchar2,
    given_date in date)
    return number
is
    p_sumf number := 0;
    f_sumf number := 0;
begin
    select sum(po.p_summa) into p_sumf
    from plan_oper po, pr_cred pc
    where po.collection_id = pc.collect_plan
        and po.type_oper = 'Погашение процентов'
        and po.p_date <= to_date(given_date)
        and pc.id_client = client_id
        and pc.num_dog = number_dog
    group by pc.num_dog;
    
    select sum(f.f_summa) into f_sumf
    from fact_oper f, pr_cred p
    where f.collection_id = p.collect_fact
        and f.type_oper = 'Погашение процентов'
        and f.f_date <= to_date(given_date)
        and p.id_client = client_id
        and p.num_dog = number_dog
    group by p.num_dog;
    
    return (p_sumf - f_sumf);
exception
    when no_data_found then
    dbms_output.put_line('Нет данных!');   
end;
/

--Создание представления "Отчет о состоянии кредитного портфеля на заданную дату"
create or replace view portfolio_condition as
    select  p.num_dog Num_Dog, 
            c.cl_name FIO, 
            p.summa_dog Sum_Dog, 
            p.date_begin Date_Begin, 
            p.date_end Date_End, 
            balance (c.id, p.num_dog, sysdate) Loan_balance_as_of_date,
            calculate_of_percent (c.id, p.num_dog, sysdate) Amount_of_Upcoming_Interest_to_Maturity,
            to_char(sysdate, 'dd.mm.yy hh24:mi:ss') Date_time_of_report_generation
    from pr_cred p, client c
    where p.id_client = c.id;
        
select * from portfolio_condition order by FIO --where Date_Begin = '22.07.20';
