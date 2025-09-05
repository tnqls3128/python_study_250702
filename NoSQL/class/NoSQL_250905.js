use sample_mflix

// 1. 각 사용자 문서에 commentsCount필드를 추가하여 댓글 개수 계산
db.users.find()
db.comments.find()


db.comments.aggregate([
    {
        $group : {
            _id : "$email",
            commentsCount : {$sum : 1}
        }
    },    
        {$lookup :
            {
                from : "users",
                localField : "_id",
                foreignField : "email",
                as :  "userInfo"
            }
    },
    {$unwind : "$userInfo"},
    {$project :
        {
            _id : 0, name : "$userInfo.name", email : 1, commentsCount : 1
        }
    }
])


// 2. 댓글 길이를 기준으로 100자 이상 "LONG COMMENT", 100자 미만 "SHORT COMMENT" 라는 새 필드를 $cond로 추가
