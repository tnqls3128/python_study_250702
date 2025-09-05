use sample_mflix

// 과제1. movie컬렉션에서 영화제작이 2010년 이상이고 장르에 "Action"이 포함된 영화의 title, year, genres 조회

db.movies.find(
    {year : {$gte : 2010}, genres : "Action"},
    {_id : 0, title : 1, year : 1, genres : 1
    }
)

db.movies.aggregate([
    {$match : {year : {$gte : 2010}, genres : "Action"}},
    {$project : {_id : 0, title : 1, year : 1, genres : 1}}
])


// 과제2. 새로운 고객 홍길동을 users 컬렉션에 추가 , 이메일은 "hong@test.com" , 관심장르는 ["Action", "Comedy"] 입니다

db.users.insertOne({
    name : "홍길동",
    email : "hong@test.com",
    password : "test123",
    preference : ["Action", "Comedy"],
    createdAt : new Date(),
})

db.users.find({name  : "홍길동"})

db.users. aggregate([
    {$documents : [
       {
            name : "홍길동1",
            email : "hong@test.com",
            password : "test123",
            preference : ["Action", "Comedy"],
            createdAt : new Date()
       } 
    ]},
    {$merge : {into : "uesers"}}
])



// 과제3. comments 컬렉션에 홍길동이 "Action 영화 최고!"라는 댓글을 삽입
// 이후 "홍길동"의 댓글 내용을 "Action 영화 진짜 재밌다!"로 수정

db.comments.find().limit(5)

// 5a9427648b0beebeb69579cf

db.comments.insertOne({
    name : "홍길동",
    email : "hong@test.com",
    movie_id : "5a9427648b0beebeb69579cf",
    text : "Action 영화 최고",
    date : new Date()
})

db.comments.find({name : "홍길동"})

/*
* javascript => 변수를 선언할 때, const, let, var
* const => 재선언, 재할당 불가 // 엄격한 변수
* let => 재선언 불가, 재할당 가능 // 상대적으로 덜 엄격한 변수
* var => 재선언, 재할당 가능
*/

const m = db.movies.findOne(
    {year : {$gte : 2010}, genres : "Action"},
    {_id : 1, title : 1}
)

m._id

db.comments.insertOne({
    name : "홍길동1",
    email : "hong@test.com",
    movie_id : m._id,
    text : "Action 영화 최고",
    date : new Date()
})

db.comments.find({name : "홍길동1"})

db.comment.updateOne(
    {email : "hong@test.com", movie_id : m._id},
    {$set : {text : "Action 영화 진짜 재밌다!", editedAt : new Date()}}
    )


// 과제4. movies 컬렉션에서 장르별 영화 수를 집계하고, 가장 많은 3개 장르를 출력

db.movies.aggregate([
    {$unwind : "$genres"},
    {$group : {_id : "$genres", count : {$sum : 1}}},
    {$sort : {count : -1}},
    {$limit : 3}
])


// 과제5. movies 컬렉션에서 평점이 8.5 이상인 영화의 title, imdb.rating, year를 출력하고, 최신 영화 순으로 정렬

db.movies.find(
    {"imdb.rating" : {$gte : 8.5}},
    {_id : 0, title : 1, year : 1, "imdb.rating" : 1}
).sort({year : -1})

db.movies.aggregate([
    {$match : {"imdb.rating" : {$gte : 8.5}}},
    {$project : {_id : 0, title : 1, year : 1, "imdb.rating" : 1}},
    {$sort : {year : -1}}
])


// 과제6. comments에서 *사용자(email 기준)*별 총 댓글 수, 댓글 평균 길이를 집계하고, 총 댓글 수 내림차순 → 
// 평균 길이 내림차순으로 정렬하여 상위 5명을 출력

db.comments.aggregate([
    {$addFields : {textStr : {$convert : 
        {input : "$text", to : "string", onError : "", onNull : ""}}}},
    {$addFields : {textLen : {$strLenCP : "$text"}}},
    {$group : {_id : "$email", totalComments : {$sum : 1}, evgTextLength : {$avg : "$textLen"}}},
    {$sort : {totalComments : -1, evgTextLength : -1}},
    {$limit : 5}
])

db.comments.aggregate([
    {$addFields : {textLen : {$strLenCP : {$ifNull : ["$text", ""]}}}},
    {$group : {_id : "$email", totalComments : {$sum : 1}, evgTextLength : {$avg : "$textLen"}}},
    {$sort : {totalComments : -1, evgTextLength : -1}},
    {$limit : 5}
])
