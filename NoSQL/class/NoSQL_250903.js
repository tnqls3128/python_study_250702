/*
1. 데이터 삽입 (Insert)
- 고객 리뷰 10개를 `reviews` 컬렉션에 저장하세요.
- 각 리뷰 문서는 `customer_name`, `product`, `rating`, `comment`, `date` 필드를 포함해야 합니다.
2. 데이터 조회 (Find)
- 별점(`rating`)이 4점 이상인 리뷰만 조회하세요.
- 특정 제품(`product`)의 리뷰만 필터링하세요.
3. 데이터 수정 (Update)
- 한 고객의 리뷰 코멘트를 `"배송이 빨라서 만족합니다"`로 수정하세요.
- 특정 제품의 리뷰 별점을 일괄적으로 `+1` 해보세요.
4. 데이터 삭제 (Delete)
- 오래된 리뷰(`date` 기준 1년 이상 지난 것)를 삭제하세요.
*/
use funcoding
db.createCollection("reviews")
show collections
db.reviews.insertMany(
    [
        {customer_name : "쿵이", product : "닭가슴살", rating : "4", comment : "맛있어요", date : ISODate("2025-08-15")},
        {customer_name : "심쿵이", product : "닭가슴살", rating : "4", comment : "굿", date : ISODate("2024-01-08")},
        {customer_name : "김수빈", product : "주먹밥", rating : "4", comment : "괜찮아요", date : ISODate("2025-06-05")},
        {customer_name : "숩", product : "도시락", rating : "2", comment : "맛없어요", date : ISODate("2024-02-15")},
        {customer_name : "수비니", product : "도시락", rating : "4", comment : "간편해요", date : ISODate("2025-02-05")},
        {customer_name : "김심쿵", product : "만두", rating : "4", comment : "좋아요", date : ISODate("2024-04-15")},
        {customer_name : "김심쿵", product : "만두", rating : "2", comment : "짜요", date : ISODate("2025-07-15")},
        {customer_name : "sk", product : "김밥", rating : "5", comment : "만족해요", date : ISODate("2025-04-15")},
        {customer_name : "쿵이", product : "김밥", rating : "4", comment : "굿굿", date : ISODate("2025-08-11")}
    ]
)
db.reviews.find()
db.reviews.find(
    {rating : {$gte : "4"}}
)
db.reviews.find(
    {product : "닭가슴살"}
)
db.reviews.updateOne(
    {customer_name : "쿵이"},
    {$set : {comment : "배송이 빨라서 만족합니다"}}
)

db.reviews.updateMany(
    {project : "주먹밥"},
    {$inc : {rating : 1}}
)

db.reviews.deleteMany(
    {date : {$lt : ISODate("2024-08-15")}}
)