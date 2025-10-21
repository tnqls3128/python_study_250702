//MongoDB -> No SQL, Aggregation -> 집합 | 집계
// Aggregation -> 프레임워크
// $push <-> 배열이 아닌 요소들을 하나의 배열의 자료구조 형태로 만들어주는 기능
// 프레임워크 | 라이브러리 
// 기존에 학습했던 find()의 상위호환 버전이라고 생각해도 무방
// Linux운영체제 -> pipeline 개념을 벤치마킹 -> 함수의 기능이 구현 -> 기능
// shard(독립적인 각각의 요소) : 샤드 -> A (*1번 샤드) -> B (*2번 샤드) 

use sample_mflix
db. movies.find()
db.comments.find()

db.movies.aggregate(
    [
        {$match : {year : 1995}}
    ]
)
db.comments.aggregate([
    {$group : {_id : "$movie_id", commentCount:{$sum:1}}},  //
    {$project : {year : "$_id", commentCount : 1, _id : 0}}
])

db.movies.aggregate([
    {$group : {_id : "$year", runtime : {$avg : "$runtime"}}}
    //openMovies : {$sum : 1}}}  // group 고정 값 : _id, $year : 목록화
])

db.movies.find().limit(2)
db.movies.aggregate([
    {$group : {_id : "$year", minrating :{$min : "$imdb.rating"}, // "5.2" -> string
        maxrating : {$max : "$imdb.rating"}}} // 4.8 + "5.2" -> 자동 형변환 X
    //averageRating : {$avg : "$imdb.rating"}}}
])

db.movies.aggregate([
    {$group : {_id : "$year", titles : {$push : "$title"}}}  //push : 배열의 형태로 만듦 
])

db.movies.find(
    {"imdb.rating" : ""}
).limit(5)

db.movies.aggregate([
    {$addFields : {
        ratingNum : {
            $convert : {
                input : "$imdb.rating", 
                to : "double",  // 실수자료형으로 자료의 값을 변경하는 역할
                onError : null, // "", "abc" -> null
                onNull : null // 진짜 null -> null
               }
            }
        }
    },  
    {
        $match : {ratingNum : {$ne : null}}  // 숫자로 변환되어진 값만 찾아옴(null이아닌값)
    },
    {
        $group : {
            _id : "$year",
            minRating : {$min : "$ratingNum"},
            maxRating : {$max : "$ratingNum"}
        }
    }
])

db.movies.aggregate([
    {$group : {_id : "$year", directors : {$push : "$directors"}}} // 기존 데이터가 배열의 형태 -> 다시 배열로 가지고 온 상황
])

// $addToSet : 동일한 중복값을 제거하고 하나로 가져오는 역할
// 동일한 감독의 값을 가지고 있었을 경우, 1번만 출력
db.movies.aggregate([
    {$group : {_id : "$year", directors : {$addToSet : "$directors"}}} 
])

db.movies.aggregate([
    {$unwind : "$genres"},
    {$group : {_id : "$year", genres : {$addToSet : "$genres"}}}  
    // ex. 1932년 -> [스포츠], [스포츠] 중 1개의 값만 가져옴, 객체지향언어 -> set함수 -> 중복되는 값을 제거하고 1번만 가져오는 함수
])

db. movies.find()

db.movies.aggregate([
    {$group : {_id : "$year", firstMovie : {$first : "$title"},  // 각 연도마다 첫번째 나오는 영화제목
    lastMovie : {$last : "$title"}}} 
])

db.movies.aggregate([
    {$group : {
        _id : "$year",
        avgTitleLength : {
            $avg : {
                $strLenCP : {
                    $toString : "$title"
                   }
                }
            }
        }
    } 
])

db.movies.aggregate([
    {$match : {year : {$gte : 2000}}},
    {$count : "movies_since_2000"}
])

db.movies.find().limit(5)  // 메서드 체이닝 기법

db.movies.aggregate([
    {$sort : {"year" : 1, "title" : 1}},
    {$limit : 10}
])

db.movies.aggregate([
    {$sort : {"imdb.rating" : 1}},
    {$limit : 5}
]) 

// 1. 2000년 이후로 출시된 영화의 수는 몇 개인가요?
db.movies.aggregate([
    {$match : {year : {$gte : 2000}}},
    {$count : "total_movies"}   // 집계할 때 -> 뒤에 필드명 
])

//2. 각 연도별로 (*group) 출시된 영화의 개수는? 
db.movies.aggregate([
    {$group : {_id : "$year", count : {$sum : 1}}},
    {$sort : {_id : 1}}
])

// 3. 가장 많은 영화가 출시된 연도는 언제일까?
db.movies.aggregate([
    {$group : {_id : "$year", count : {$sum : 1}}},
    {$sort : {count : -1}},
    {$limit : 1}
])

// 4. 각 연도별 평균 영화 러닝타임은 어떻게 될까요?
db.movies.aggregate([
    {$group : {_id : "$year", average : {$avg : "$runtime"}}},
    {$sort : {average : -1}}
])

// 5. 가장 러닝타임이 긴 영화는 어떤 영화인가요?
db.movies.aggregate([
    {$sort : {runtime : -1}},
    {$limit : 1}
])

// 6. 각 영화 장르별 평균 평점은 어떻게 될까요?
db.movies.aggregate([
    {$unwind : "$genres"},  // 배열 하나 없애는 것 문자열로 가지고옴
    {$group : {_id : "$genres", avgRating : {$avg : "$imdb.rating"}}},
    {$sort : {avgRating : -1}}
])

// 7. 각 연도별 영화 제목의 평균길이를 구해주세요
db.movies.aggregate([
    {$group : {_id : "$year", avgTitleLength : {$avg : {$strLenCP : {$toString : "$title"}}}}},
    {$sort : {avgTitleLength : 1}}
])

// 8. 각 연도별 가장 먼저 출시된 영화의 제목은 무엇인가요?
db.movies.aggregate([
    {$sort : {"year" : 1, "released" : 1}},
    {$group : {_id : "$year", firstMovie : {$first : "$title"}}}
])

// 9. 각 연도별 개봉된 영화의 장르들을 출력해주세요 (단, 장르는 1번씩만 출력)
db.movies.aggregate([
    {$unwind : "$genres"},
    {$group : {_id : "$year", uniqueGenres : {$addToSet : "$genres"}}},
    {$sort : {_id : 1}},
    {$project : {year : "$_id", genrens : "$uniqueGenres", _id : 0}}
])



db.movies.aggregate([
    {$project : {
        title : 1,
        year : 1, 
        _id : 0,
        releasedIn : {$concat : ["$title", "/", {$toString : "$year"}]}
        }
    },
    {$limit : 5}
])