USE mysql;

SELECT host, user FROM user;

# localhost => 127.0.01 => DNS

CREATE USER 'david7'@'localhost'
IDENTIFIED BY 'david1234';

SHOW GRANTS FOR 'root'@'localhost';
SHOW GRANTS FOR 'david7'@'localhost';

CREATE USER 'david8'@'%'   # 모든 IP 주소에서 접속 허용
IDENTIFIED BY 'david1234';

SET PASSWORD FOR 'david7'@'localhost' = 'david5678';

DROP USER 'david7'@'localhost';
DROP USER 'david8'@'%';

GRANT SELECT ON school.students TO 'david7'@'localhost';
GRANT ALL ON school.* TO 'david7'@'localhost';