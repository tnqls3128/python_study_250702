USE sqldb_v1;

DESC usertbl;
# 클러스터형 인덱스 : userID

DESC buytbl;
# 클러스터형 인덱스 : num

SHOW INDEX FROM buyTbl;
SHOW INDEX FROM userTbl;

ALTER TABLE userTbl ADD CONSTRAINT TESTdate UNIQUE (mDate);

CREATE INDEX idx_birth ON userTbl(birthYear);

ALTER TABLE userTbl ADD INDEX idx_addr(addr);

ALTER TABLE userTbl DROP INDEX idx_addr;