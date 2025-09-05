// 특정 조건에 부합하는 경우 통으로 문서를 대체(*replace) 하는 구문 
db.user.find()

db.user.updateOne(
    {name : "동현"},
    {$set:{name : "동현2", age : 31, hobbies : ["축구", "음악", "영화"]}}
)

db.user.find(
    {name : "동현2"}
)

// 5. 특정 조건에 따라서 필드를 제거하는 문법/구문
db.user.updateOne(
    {name : "유진"},
    {$unset : {age : 1}}
)

// 특정 조건을 만족하는 문서가 없는 경우 새로 추가하기
db.user.updateOne(
    {name : "민준"},
    {$set : {name : "민준", age : 22, hobbies : ["음악", "여행"]}},
    {upsert : true}   // 조건에 충족되진않지만 결과 나옴
)

db.user.updateOne(
    {name : "유진"},
    {$set : {age : 30}}
)

db.user.updateOne(
    {name : "유진"},
    {$set : {hobbies : "운동"}}
)

db.user.find()

// 특정 컬럼 내 배열 형태의 자료에서 값을 추가 : push
db.user.updateOne(
    {name : "유진"},
    {$push : {hobbies : "영화"}}  // 기존 배열에서 값을 추가 : push
)

// 특정 컬럼 내 배열 형태의 자료에서 값을 제거 : pull
db.user.updateOne(
    {name : "유진"},
    {$pull : {hobbies : "운동"}}
)

/*
특정 컬렉션 안에 값을 추가할 때에도 단일값 & 다중값 적용
값을 수정할 때에도 단일값 & 다중값 적용
값을 삭제할 때에도 단일값 & 다중값 적용
*/

// deletaOne, deleteMany

/*
DELETE FROM user WHERE address = "서울";
db.user.deletMany(
    {address : "서울"}
)

DELETE FROM user;

*/

db.user.deleteMany(
    {adress : "수원시"}
)

db.user.insertMany([
    {name: "David" , age: 45, adress : "서울"},
    {name:"DavidLee", age: 25, adress : "경기도"},
    {name: "Andy", age: 50 , hobby : "골프" , adress : "경기도"},
    {name: "Kate", age: 35, adress : "수원시"}
])

db.user.deleteMany(
    {age : {$lt : 30}}
)
db.user.find()

db.user.insertMany(
    [
        {name : "A", age : 20, adress : "경기도", date : ISODate("2025-08-15")},
        {name : "B", age : 30, adress : "서울", date : ISODate("2025-06-15")},
    ]
)

db.user.updateMany(
    {adress : "경기도"},
    {$inc: {age : 1}}
)

db.user.deleteMany(
    {date : {$lt : ISODate("2025-09-01")}}
)

