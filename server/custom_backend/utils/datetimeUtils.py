import pytz
from datetime import datetime, timedelta

indian_timezone = pytz.timezone('Asia/Kolkata')

def startEndTime():
    
    current_datetime = datetime.now()
    midnight_datetime = current_datetime.replace(hour=0, minute=0, second=0, microsecond=0)

    one_day = timedelta(days=1)
    yesterday_midnight_datetime = current_datetime - one_day
    yesterday_midnight_datetime = yesterday_midnight_datetime.replace(hour=0, minute=0, second=0, microsecond=0)

    start_date = indian_timezone.localize(yesterday_midnight_datetime)
    end_date = indian_timezone.localize(midnight_datetime)
    
    return start_date, end_date

def testStarttime():
    return datetime(2023, 1, 1, tzinfo=indian_timezone)