create table company(
companyNo varchar2(200) primary key,
companyName varchar2(200) not null
);
create table employee(
companyNo varchar2(200) not null,
empId varchar2(200) primary key,
empPassword varchar2(200) not null,
empName varchar2(200) not null,
empDept varchar2(200) not null,
empAuthorization varchar2(200) default 'employee',
empPhone varchar2(200) not null,
constraint FK_cascade foreign key(companyNo) references company(companyNo) on delete cascade
);
create table business(
empId varchar2(200) not null,
businessNo number primary key,
businessName varchar2(200) not null,
businessWith number ,
businessColor varchar2(200),
businessStart date,
businessEnd date,
businessRepresent varchar(20) default 'false' check (businessRepresent in( 'true','false')) ,
businessLocationMain varchar2(200),
businessLocationSub varchar2(200),
businessMemo varchar2(200),
constraint FK_cascade1 foreign key(empId) references employee(empId) on delete cascade
);
create table schedule(
businessNo number not null,
scheduleNo number primary key,
scheduleTitle varchar2(200) not null,
scheduleDay date ,
scheduleContext varchar2(200) not null,
schedulePlace varchar2(200),
constraint FK_cascade2 foreign key(businessNo) references business(businessNo) on delete cascade
); 
create table recipe(
scheduleNo number not null,
recipeNo number primary key,
recipeDay date,
recipePlace varchar2(200) not null,
recipePay varchar2(200) default 'card',
recipeMemo varchar2(200) not null,
constraint FK_cascade3 foreign key(scheduleNo) references schedule(scheduleNo) on delete cascade
);
create table item(
recipeNo number not null,
itemNO number primary key,
itemCategory varchar2(200) not null,
itemName varchar2(200) ,
itemCount number,
itemPrice number,
constraint FK_cascade4 foreign key(recipeNo) references recipe(recipeNo) on delete cascade
);
create table total(
scheduleNo number not null,
empId varchar2(200) not null,
constraint FK_for foreign key (scheduleNo) references schedule(scheduleNo) on delete cascade,
constraint FK_for2 foreign key (empId) references employee(empId) on delete cascade
);


insert into company values(
1111,'삼성'
);
insert into company values(
2222,'LG'
);
insert into company values(
3333,'KT'
);
insert into company values(
4444,'현대'
);
insert into company values(
5555,'대우'
);
insert into company values(
6666,'CJ'
);
insert into company values(
7777,'신세계'
);
insert into company values(
8888,'CGV'
);
insert into employee values(1111,'b123','b123','이병권','인사과','employee','0123');
insert into employee values(1111,'c123','c123','하광석','개발과','employee','0123');
insert into employee values(1111,'d123','d123','길준성','개발과','employee','0123');
insert into employee values(1111,'f123','f123','최지원','경리과','employee','0123');
insert into employee values(1111,'g123','g123','김유리','경리과','employee','0123');
insert into employee values(1111,'h123','h123','조현경','경리과','employee','0123');
insert into employee values(1111,'i123','i123','전지수','경리과','employee','0123');
insert into employee values(1111,'j123','j123','배민준','보안과','employee','0123');
insert into employee values(2222,'k123','k123','김병희','디자인과','employee','0123');
insert into employee values(2222,'w123','w123','조성민','디자인과','employee','0123');
insert into employee values(2222,'z123','z123','김대영','디자인과','employee','0123');
insert into employee values(2222,'j1123','j1123','이흥륜','보안과','employee','0123');
insert into employee values(2222,'j1223','j1223','문종찬','보안과','employee','0123');
insert into employee values(2222,'j1323','j1323','김태희','보안과','employee','0123');
insert into employee values(2222,'j1423','j1423','배민준','보안과','employee','0123');

insert into employee values(3333,'a1423','a1423','김도연','디자인과','employee','0123');
insert into employee values(3333,'b1423','b1423','채수빈','디자인과','employee','0123');
insert into employee values(3333,'c1423','c1423','김진우','디자인과','employee','0123');
insert into employee values(3333,'d1423','d1423','지하람','개발과','employee','0123');
insert into employee values(3333,'e1423','e1423','김선진','개발과','employee','0123');
insert into employee values(3333,'f1423','f1423','송아름','개발과','employee','0123');
insert into employee values(3333,'h1423','h1423','이민선','보안과','employee','0123');
insert into employee values(3333,'i1423','i1423','김다란','보안과','employee','0123');
insert into employee values(3333,'k1423','k1423','이보나','인사과','employee','0123');
insert into employee values(3333,'m1423','m1423','김선민','인사과','employee','0123');
insert into employee values(3333,'n1423','n1423','김형모','인사과','employee','0123');


insert into employee values(4444,'a11423','a11423','김혜미','영업과','employee','0123');
insert into employee values(4444,'a12423','a12423','전지은','영업과','employee','0123');
insert into employee values(4444,'a13423','a13423','김수림','영업과','employee','0123');
insert into employee values(4444,'a14423','a14423','김하나','마케팅과','employee','0123');
insert into employee values(4444,'a15423','a15423','민용기','마케팅과','employee','0123');
insert into employee values(4444,'a16423','a16423','김형진','마케팅과','employee','0123');
insert into employee values(4444,'a17423','a17423','오징어','마케팅과','employee','0123');
insert into employee values(4444,'a18423','a18423','박정우','인사과','employee','0123');
insert into employee values(4444,'a19423','a19423','하정우','인사과','employee','0123');
insert into employee values(4444,'a10423','a10423','현아','군수과','employee','0123');
insert into employee values(4444,'a1123423','a1123423','김태연','군수과','employee','0123');
insert into employee values(4444,'a144423','a144423','사랑해','군수과','employee','0123');

insert into business values('f123',300,'제주도출장',1,'#FFFF00','18/09/20','18/09/22','true','제주특별자치도','중문','없음');
insert into business values('f123',301,'부산출장',2,'#FFFF00','18/09/27','18/09/30','true','부산광역시','서면','없음');
insert into business values('g123',302,'광주출장',3,'#FFFF00','18/09/27','18/09/30','true','광주광역시','광주역','없음');
insert into business values('h123',303,'전주출장',4,'#FFFF00','18/09/27','18/09/30','true','전라북도','전주시','없음');
insert into business values('h123',304,'강원도출장',5,'#FFFF00','18/10/02','18/10/07','true','강원도','삼척시','없음');



insert into business values('a1423',305,'인천출장',6,'#FFFF00','18/09/29','18/10/03','true','인천광역시','인천공항','없음');


insert into schedule values(300,300,'흑돼지','18/09/20','없음','중문시내');
insert into schedule values(300,301,'호텔예약','18/09/20','없음','중문시내');
insert into schedule values(300,302,'렌트차','18/09/20','없음','중문시내');
insert into schedule values(300,303,'비즈니스미팅','18/09/21','없음','중문시내');
insert into schedule values(300,304,'자사유치','18/09/22','없음','중문시내');
insert into schedule values(301,305,'바이오미팅','18/09/27','없음','서면시내');
insert into schedule values(301,306,'컨퍼런스참여','18/09/28','없음','서면시내');
insert into schedule values(301,307,'업무보고','18/09/29','없음','서면시내');
insert into schedule values(302,308,'공장확인','18/09/27','없음','광주시내');
insert into schedule values(302,309,'비즈니스확인','18/09/28','없음','광주시내');
insert into schedule values(302,310,'지사유치','18/09/29','없음','광주시내');
insert into schedule values(302,311,'호텔','18/09/29','없음','광주시내');
insert into schedule values(303,312,'지사증축','18/09/27','없음','전주시내');
insert into schedule values(303,313,'미팅','18/09/29','없음','전주시내');
insert into schedule values(303,314,'박람회 참가','18/09/30','없음','전주시내');
insert into schedule values(304,315,'고구마 행사 참가','18/10/02','없음','강원도시내');
insert into schedule values(304,316,'감자농자매수','18/10/03','없음','강원도시내');
insert into schedule values(304,317,'옥수수농장매수','18/10/05','없음','강원도시내');
insert into schedule values(304,318,'계약협정','18/10/07','없음','강원도시내');

insert into schedule values(305,319,'바이오마중','18/09/29','없음','인천공항');
insert into schedule values(305,320,'바이오투어','18/09/30','없음','인천시내');
insert into schedule values(305,321,'역사투어','18/10/01','없음','강화도');

insert into recipe values(300,300,'18/09/20','고기집','card','없음');
insert into recipe values(301,301,'18/09/20','신라호텔','card','없음');
insert into recipe values(302,302,'18/09/20','쏘카','card','없음');
insert into recipe values(303,303,'18/09/21','팡팡이횟집','card','없음');
insert into recipe values(304,304,'18/09/22','지드래곤카페','card','없음');
insert into recipe values(304,305,'18/09/22','드라곤호텔','card','없음');
insert into recipe values(305,306,'18/09/27','연구소','card','없음');
insert into recipe values(306,307,'18/09/28','아쿠아돔','card','없음');
insert into recipe values(307,308,'18/09/29','발렌시아가','card','없음');
insert into recipe values(308,309,'18/09/27','돼지갈비찜','card','없음');
insert into recipe values(308,310,'18/09/27','Gs칼텍스','card','없음');
insert into recipe values(309,311,'18/09/28','신라관','card','없음');
insert into recipe values(310,312,'18/09/29','킨텍스','card','없음');
insert into recipe values(310,313,'18/09/29','화룡각','card','없음');
insert into recipe values(311,314,'18/09/29','하얏트호텔','card','없음');
insert into recipe values(312,315,'18/09/27','KTX','card','없음');
insert into recipe values(312,316,'18/09/27','취락당','card','없음');
insert into recipe values(312,317,'18/09/27','배테랑','card','없음');
insert into recipe values(312,318,'18/09/27','모주','card','없음');
insert into recipe values(312,319,'18/09/27','한복기웃','card','없음');
insert into recipe values(313,320,'18/09/29','경기전','card','없음');
insert into recipe values(313,321,'18/09/29','객사파스타','card','없음');
insert into recipe values(314,322,'18/09/30','문크라우드','card','없음');
insert into recipe values(314,323,'18/09/30','KTX','card','없음');
insert into recipe values(315,324,'18/10/02','GS칼텍스','card','없음');
insert into recipe values(315,325,'18/10/02','옥수수국수','card','없음');
insert into recipe values(315,326,'18/10/02','호롱모텔','card','없음');
insert into recipe values(316,327,'18/10/03','강원도두중국집잇다','card','없음');
insert into recipe values(316,328,'18/10/03','sk칼텍스','card','없음');
insert into recipe values(316,329,'18/10/03','오빠모텔','card','없음');
insert into recipe values(317,330,'18/10/05','삼척횟집','card','없음');
insert into recipe values(317,331,'18/10/05','봉구미','card','없음');
insert into recipe values(317,332,'18/10/05','자기모텔','card','없음');
insert into recipe values(318,333,'18/10/07','횡성한우집','card','없음');
insert into recipe values(318,334,'18/10/07','SK칼텍스','card','없음');
insert into recipe values(318,335,'18/10/07','춘천휴게소','card','없음');

insert into recipe values(319,336,'18/09/29','인천면세점','card','없음');
insert into recipe values(319,337,'18/09/29','콜벤','card','없음');
insert into recipe values(319,338,'18/09/29','포차끝판왕','card','없음');
insert into recipe values(319,339,'18/09/29','다우라호텔','card','없음');

insert into recipe values(320,340,'18/09/30','콜벤','card','없음');
insert into recipe values(320,341,'18/09/30','하늘본닭','card','없음');
insert into recipe values(320,342,'18/09/30','차이나타운','card','없음');


insert into recipe values(321,343,'18/10/01','전등사관람','card','없음');
insert into recipe values(321,344,'18/10/01','막국수','card','없음');
insert into recipe values(321,345,'18/10/01','달마호텔','card','없음');
insert into recipe values(321,346,'18/10/01','강화주요소','card','없음');


insert into item values(300,300,'식비','흑돼지',2,15000);
insert into item values(301,301,'숙박비','스위트룸',1,300000);
insert into item values(302,302,'교통비','렌트카',1,150000);
insert into item values(303,303,'식비','우럭',1,70000);
insert into item values(303,304,'식비','스시',1,7000);
insert into item values(304,305,'접대비','커피',3,4000);
insert into item values(304,306,'접대비','케익',3,7000);
insert into item values(305,307,'숙박비','모던룸',1,10000);
insert into item values(306,308,'교통비','KTX',1,34000);
insert into item values(306,309,'식비','오니기리',3,3000);
insert into item values(307,310,'유류비','주유소',1,10000);
insert into item values(307,311,'기타','입장권',3,15000);
insert into item values(308,312,'접대비','18SS쇼퍼백',1,150000);
insert into item values(308,313,'접대비','18SS워커',1,100000);
insert into item values(309,314,'식비','매운갈비찜',3,7000);
insert into item values(310,315,'유류비','기름충전',1,70000);
insert into item values(311,316,'접대비','코스요리',2,70000);
insert into item values(312,317,'기타','입장권',2,40000);
insert into item values(312,318,'식비','깐쇼새우코스',1,80000);
insert into item values(314,319,'숙박비','다이닝룸',1,10000);
insert into item values(315,320,'교통비','승차권',1,10000);
insert into item values(316,321,'숙박비','객실',1,10050);
insert into item values(317,322,'식비','칼국수',3,7000);
insert into item values(318,323,'접대비','모주',3,10000);
insert into item values(319,324,'기타','한복체험',1,15000);
insert into item values(320,325,'기타','입장권',3,5000);
insert into item values(321,326,'식비','갈릭파스타',2,13000);
insert into item values(321,327,'식비','봉골레파스타',1,13000);
insert into item values(321,328,'식비','콜라',2,1500);
insert into item values(322,329,'접대비','다과',1,150000);
insert into item values(323,330,'교통비','KTX',3,150000);
insert into item values(324,331,'유류비','기름주유',1,100000);
insert into item values(325,332,'식비','옥수수국수',2,7000);
insert into item values(326,333,'숙박비','숙소예약',1,70000);
insert into item values(327,334,'식비','깐쇼새우',1,40000);
insert into item values(327,335,'식비','짜장면',2,6000);
insert into item values(328,336,'유류비','기름주유',2,60000);
insert into item values(329,337,'숙박비','숙소예약',1,80000);
insert into item values(330,338,'식비','광어',1,80000);
insert into item values(330,339,'식비','우럭',1,50000);
insert into item values(331,340,'기타','가위',1,4000);
insert into item values(332,341,'숙박비','숙소예약',1,100000);
insert into item values(332,341,'숙박비','숙소예약',1,100000);
insert into item values(333,342,'접대비','등심',3,90000);
insert into item values(333,343,'접대비','목살',2,50000);
insert into item values(333,344,'접대비','소주',5,5000);
insert into item values(334,345,'유류비','기름주유',1,60000);
insert into item values(335,346,'식비','돈가스',2,7000);

insert into item values(336,347,'접대비','롤렉스',1,7000000);
insert into item values(337,348,'교통비','콜벤',1,50000);
insert into item values(338,349,'식비','규동',3,8000);
insert into item values(339,350,'숙박비','숙소예약',1,11000);

insert into item values(340,351,'교통비','콜벤',1,60000);
insert into item values(341,352,'대접비','매운닭갈비',2,8000);
insert into item values(341,353,'대접비','콜라',2,1000);

insert into item values(342,354,'기타','입장권',2,3000);
insert into item values(343,355,'기타','입장권',3,4000);
insert into item values(344,356,'식비','막국수',3,10000);
insert into item values(344,357,'식비','콜라',3,1000);
insert into item values(345,358,'숙박비','숙소예약',1,100000);
insert into item values(346,359,'유류비','기름주유',1,60000);
commit;