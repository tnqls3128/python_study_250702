// 1. users 문서에 commentsCount 필드를 추가하고 댓글 개수계산
//2. 댓글길이를 기준으로 100자 이상 => LONG COMMMENT, 100자 미만 => SHORT COMMENT

use sample_mflix
db.users.find().limit(1)
db.comments.find().limit(1)

db.users.aggregate([
    {
        $lookup: {
            from: "comments",
            localField: "email",
            foreignField: "email",
            as: "C"
        }
    },
    {
        $addFields: {
            commentsCount: { $size: "$C" },
            commentsAnnotated: {
                $map: {
                    input: "$C",
                    as: "x",
                    in: {
                        text: "$$x.text",
                        date: "$$x.date",
                        movie_id: "$$x.movie_id",
                        commentType: {
                            $cond: [
                                { $gte: [{ $strLenCP: { $ifNull: ["$$x.text", ""] } }, 100] },
                                "LONG COMMENT",
                                "SHORT COMMENT"
                            ]
                        }
                    }
                }
            }
        }
    }
])            
        // array = 배열 = list, iterable = 반복순회가능한 자료구조, 
        // for in => .js => 반복순회 가능한 자료구조를 찾아와서 내부에 있는 값을 하나씩 연산처리 후 다시 새로운 배열 반환해주는 문법 *map        

//3. 아래 3개의 내용을 $facet (*파이프 라인의 순서와 상관없이 동시 실행)
//(1) 최신영화 Top5
//(2) 고평점 영화 개수 (*8점 이상)
//(3) 장르별 영화 분포
db.movies.aggregate([
  {
    $facet: {
      latest5: [
        { $sort: { year: -1 } },
        { $limit: 5 },
        { $project: { _id: 0, title: 1, year: 1 } }
      ],
      highRatedCount: [
        { $match: { "imdb.rating": { $gte: 8 } } },
        { $count: "count" }
      ],
      genresByCount: [
        { $unwind: "$genres" },
        { $group: { _id: "$genres", count: { $sum: 1 } } },
        { $sort: { count: -1 } }
      ]
    }
  },
  {
    $project: {
      latest5: 1,
      highRatedCount: {
        $ifNull: [
          { $arrayElemAt: ["$highRatedCount.count", 0] },  
          0
        ]
      },
      genresByCount: 1
    }
  }
])