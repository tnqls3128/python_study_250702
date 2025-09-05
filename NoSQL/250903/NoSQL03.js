// 로컬컴퓨터 내 db목록 확인
show dbs

// 특정 db에 접속
use Funcoding
use sql01

// 특정 db안에 컬렉션을 보고자 할 때
show collections

// 특정 컬렉션안에 데이터를 확인하고자할 때
db.test.find()

// 특정 DB의 상태정보를 확인할 때
db.status()

// 특정 db를 삭제하고자 할 때 -> 주의해야할 사항
// db가 삭제된다는 것은 당연히 db안에 있는 컬렉션으로 같이 삭제가 된다는 의미
db.dropDatabase()

// 특정 db > 컬렉션 삭제
db.test.drop()

// 컬렉션 생성 -> CLI 방식 VS GUI 방식
db.createCollection("test")

use funcoding

// 컬렉션을 생성하는 2가지 방식 
/*
1)  특정 옵션 없이 단순 컬렉션 생성 방식
2) 별도의 옵션을 설정해서 컬렉션 생성 방식 
- capped : true => 고정된 크기의 컬렉션을 갖도록 하겠다는 의미
- size : byte의 단위로 입력하게끔 되어있음
    - 2진수로 데이터를 처리 -> 2진법 -> 데이터처리, 저장 단위의 최소 단위 = bit
    - 1byte = 8bit
    - 1kb = 2^10 = 1024 
    - 1mb = 1 X 1024 X 1024 = 1,048,576 bytes
    - 5mb = 5 X 1024 X 1024 = 5,242,880 bytes
- max : 해당 컬렉션 안에 저장할 수 있는 데이터 (=문서), 몇 개의 문서를 허용할 것인가
- autoIndexId : 모든 문서를 생성할 때마다 _id 필드에 대한 값을 자동으로 설정할 것인가
*/
db.createCollection("log", {
    capped : true,
    size : 5242880,
    max : 5000
})

db.log.isCapped()
db.test.isCapped()

// 이미 생성된 컬렉션 이름을 수정하고자 할 때
db.log.renameCollection("test01")

// db > collection > document
/* 
SQL :
INSERT INTO 테이블명(field name) VALUES (value)
NoSQL : 
db.collectionname.insertOne(
    {
        name : "David",
        age : 20,
        status : "pending"
    }
)

db.collectionname.insertMany(
    [
        {subject : "coffee", author : "abc", views : 50},
        {subject: "shopping", author : "def", views : 100 }
    ]
)
*/

db.createCollection("users")

db.users.insertOne(
    {subject : "coding", autor : "funcoding", views : 50}
)

// 해당 컬렉션 내부에 있는 값을 확인하고자 할 때
db.users.find()

// 해당 컬렉션 내부에 여러개 문서를 동시에 입력
db.users.insertMany(
    [
        {subject : "coffee", author : "xyz", views : 50},
        {subject : "Coffee Shopping", author : "efg", views : 50},
        {subject : "Baking a cake", author : "xyz", views : 50},
        {subject : "baking", author : "xyz", views : 50},
        {subject : "coffee", author : "xyz", views : 50},
    ]
)

// No-SQL 구문/문법은 SQL 대비 상대적으로 유연한 문법 체계를 가지고 있음
// {subject : "coffee", author : "123", views : "zyt"}

// SQL 내 Schema를 정의했던 것 처럼 NoSQL에서도 사전에 Schema Validation 유효성 기능설정
db.createCollection("users02",{
    validator : {
        $jsonSchema : {
            bsonType : "object",
            required : ["subject", "author", "views"],
            properties : {
                subject : {
                    bsonType : "string",
                    description : "must be a string and is required"
                },
                author : {
                    bsonType : "string",
                    description : "must be a string and is required"
                },
                views : {
                    bsonType : "int",
                    description : "must be a integer and is required"
                },
            }
        }
    },
    validationAction : "error"
})

db.users.drop()


//mission01. users 컬렉션 생성
// 다음과 같은 데이터를 삽입
/*
컬렉션 내 size는 100000bite로 생성
name, age, hobby, address 키 
David, 45, "서울"
Dave, 25, "경기도"
Andy, 50, "골프", "경기도"
Kate, 35, "수원시"
Brown, 8
*/
db.createCollection("user",{
     capped : true, size : 100000
})
db.user.insertMany(
    [
        {name : "David", age : 45, adress : "서울"},
        {name : "Dave", age : 25, adress : "경기도"},
        {name : "Andy", age : 50, hobby : "골프",  adress : "경기도"},
        {name : "Kate", age : 35, adress : "수원시"},
        {name : "Brown", age : 8}
    ]
)

// find() : 해당 컬렉션 안에 있는 모든 데이터를 읽기 위한 목적 함수
db.user.find()

/*
만약 특정 조건에 해당되는 값을 찾아오고 싶다면?
SELECT * FROM user ;
db.user.find()

SELECT _id, name, address FROM user
db.user.find({}, {name:1, address :1})   
> truthy = 1, falsy = 0
> {} : 직접 입력 및 삽입한 값 뿐만 아니라 자동적으로 내장되어있는 값까지 모두 찾아온다는 의미 = all
> {특정 값을 입력} : 조건

SELECT name, address FROM user
db.user.find({}, {name : 1}, {address : 1, _id : 0})  -> 처음 {} 은 필수값

SELECT * FROM user WHERE address = "서울"
db.user.find({address: "서울"})

*/

// findOne() : 매칭되어지는 최초 1개의 document 문서를 검색해서 찾아온다

// 어떤 쿼리의 조건을 의미하는 명칭 : query criteria (*기준)
/*
db.user.find(
    {age : {$gt : 18}},  -> query criteria, 모든 것 or 조건 , 18살을 초과하는 age (grate than)
    {name : 1, address : 1, _id :1}   -> projection, _id : 0이 아니면 의미 없음 위에 다 가져온다고 되어있으므로
).limit(5)  -> cursor modifier
*/

// 2. user Collection에서 Dave인 문서의 name, age, adrress, _id를 출력
db.user.find(
    {name : "Dave"}, 
    {name : 1, age : 1, adress : 1, _id : 0}
)

db.user.find(
    {name : "Kate"},
    {name : 1, age : 1, adress : 1, _id : 0}
)

// 비교 연산자
/*
$eq : = 
$gt : > 초과
$get : >= 이상
$lt : < 미만
$lte : <= 이하
$nin : not in 특정 값을 갖고 있지 않은 경우 
$in : 특정 값을 갖고있는 경우 (*배열의 자료형태 -> 복수의 값을 기준으로 검색)
$ne : not enough  (*단일 값의 형태)


SELECT * FROM user WHERE age > 25;
db.user.find({age : {$gt :25}})

SELECT * FROM user WHERE age < 25;  
db.user.find({age : {$lt :25}})

SELECT * FROM user WHERE age > 25 AND age <= 50;  
db.user.find({age : {$lte :50, $gt : 25}})
*/

db.user.find(
    {age : {$gt : 20}}
)

db.user.find(
    {age : {$lt : 25}}
)

db.user.find(
    {age : {$gt : 25, $lt : 50}}
)

db.user.find(
    {age : {$in:[45,50]}}
)

db.user.find(
    {age : {$nin:[45,50]}}
)

db.user.find(
    {age : {$ne:25}}
)

/*
1) age가 20보다 큰 문서의 name만 출력
2) age가 50이고 address가 경기도인 문서의 name만 출력
3) age가 30보다 작은 문서의 name과 age출력
*/
db.user.find(
    {age : {$gt : 20}},
    {name : 1, _id : 0}
)

db.user.find(
    {age : {$eq : 50}, adress : "경기도"},
    {name : 1, _id : 0}
)

db.user.find(
    {age : 50, adress : "경기도"},
    {name : 1, _id : 0}
)

db.user.find(
    {age : {$lt : 30}},
    {name : 1, age : 1, _id : 0}
)

// 논리연산 문법
/*
SELECT & FROM user WHERE address = "서울" AND ate = 45;
db.user.find(
    {$sand : [{address : "서울"}, {age : 45}]}
)

SELECT & FROM user WHERE address = "서울" OR ate = 45;
db.user.find(
    {$or : [{address : "서울"}, {age : 45}]}
)

SELECT & FROM user WHERE age != 45;
db.user.find({age : {$not : {$eq : 45}}})  -> $not쓸 경우 eq 생략 불가능
* eq생략이 가능한 경우 = $ne 쓸 경우
db.user.find({age : {$ne : 45}})
*/

db.user.find(
    {$and : [{adress : "서울"}, {age : 45}]}
)

// 3. name이 Brown이거나 age가 35인 모든 값 출력
db.user.find(
    {$or : [{name : "Brown"}, {age : 35}]}
)

// 정규표현식 -> 어떤 특정 문자열을 찾아오도록 설정 -> 패턴
// 해당 패턴에 부가적으로 옵션 -> 플래그
// SELECT * FROM user WHERE name like "%Da%"

db.user.find(
    {name : {$regex : /Da/}}   
)

/*
name 키 (*필드명) > 값이 "Da"로 시작하는 모든 문서를 찾아라
db.user.find(
    {name : {$regex : /^Da/}}
)

db.user.find(
    {name : /^Da/}   -> Da로 시작하는 것 포함 ^[] not의미
)

* 정렬 (sort)
SELECT * FROM user WHERE address = "경기도"
ORDER BY age ASC;

db.user.find(
    {adress : "경기도"}
).sort({age : 1})

db.user.find(
    {adress : "경기도"}
).sort({age : -1})
*/

db.user.find(
    {adress : "경기도"}
). sort({age : -1})


// 현재 컬렉션 내 문서의 개수 확인하고자 할 때 : count()
db.user.find().count()  // 정석적인 구문
db.user.count()

// 현재 컬렉션 내 필드 존재 여부로 문서 개수 확인하고자 할 때 : $exists => 속성

// $가 붙어있다는 것은 NoSQL 문법에서 예약어로 사용되고 있다
// $가 붙어있는 예약어 중에서 연산자, 속성 

db.user.count(
    {adress : {$exists : true}}
)

db.user.find({adress : {$exists : true}}).count()
db.user.find({adress : {$exists : false}}).count()

// 중복제거 : distinct
/*
SELECT DISTINCT(address) FROM user 
db.user.distinct("addtess")

* 결과값이 같은 비슷한 구문
db.user.findOne()
db.user.find().limit(1)
*/

db.user.distinct("adress")
db.user.find()



// 데이터 수정!!

// 이미 생성된 컬렉션 안에 신규값을 추가
db.user.insertMany(
    [
        {name : "유진", age : 25, hobbies : ["독서", "영화", "요리"]},
        {name : "동현", age : 30, hobbies : ["축구", "음악", "영화"]},
        {name : "혜", age : 35, hobbies : ["요리", "여행", "독서"]}
    ]
)

// $all : 배열 자료구조를 갖고 있는 필드에서 조건에 충족되는 모든 값을 포함하는 문서를 찾아올 때
db.user.find(
    {hobbies : {$all:["축구", "음악"]}}
)

// SELECT * FROM user WHERE hobbies LIKE "%축구%" AND "%음악%"

// Document 수정
/*
1) updateOne(*정석) // update
 -> 매칭되는 1개의 최초 문서 업데이트 할 때 사용
2) updateMany 
 -> 매칭되는 모든 문서를 업데이트 할 때 사용
 
db.user.updateMany(
    {age : {$gt : 25}},
    {$set : {address : "서울"}}
)

UPDATE user SET address = "서울" WHERE age > 25;
*/

// 4. age가 40보다 큰 문서의 address를 "수원시"로 변경하기
db.user.updateMany(
    {age : {$gt : 40}},
    {$set : {adress : "수원시"}}
)

db.user.find()

db.user.updateOne(
    {name : "유진"},
    {$set : {age : 26}}
)
