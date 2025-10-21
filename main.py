from dotenv import load_dotenv
import os

load_dotenv()  # 현재 디렉터리의 .env 파일 불러오기
print("API_KEY:", os.getenv("API_KEY"))  # 환경변수 API_KEY 출력
