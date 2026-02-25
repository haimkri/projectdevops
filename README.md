terraform-project/
│
├── main.tf                 # קובץ תצורה ראשי - קורא למודולים
├── variables.tf            # משתנים גלובליים
├── outputs.tf              # פלטים גלובליים
├── terraform.tfvars        # ערכים ספציפיים למשתנים
├── modules/                # תיקיית המודולים
│   ├── vpc/                # מודול VPC
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ec2/                # מודול EC2
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── s3/                 # מודול S3
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md               # תיעוד הפרויקט
vpc 
יוצר רשת וירטואלית מלאה
2 תתי רשתות ציבוריות
גישה לאינטרנט וניהול תעבורה תקין.
בנוי מ 3 קבצים:
main.tf - קובץ הגדרות המשאבים העיקרי:
variables.tf - משתנים שהמודול מקבל:
outputs.tf - ערכים שהמודול מחזיר:

EC2 
יוצר שרת וירטואלי עם Apache
EC2 instance עם Amazon Linux 2
Security Group המאפשר גישת HTTP/HTTPS
Elastic IP קבוע

התקנת Apache אוטומטית דרך user_data
בנוי מ 3 קבצים:
main.tf - קובץ הגדרות המשאבים העיקרי:
variables.tf - משתנים שהמודול מקבל:
outputs.tf - ערכים שהמודול מחזיר:

S3
יוצר Bucket מאובטח
Bucket עם שם ייחודי

Versioning - שמירת גרסאות קודמות של קבצים

הצפנה (Server-Side Encryption)

חסימת גישה ציבורית (ברירת מחדל)
בנוי מ 3 קבצים:
main.tf - קובץ הגדרות המשאבים העיקרי:
variables.tf - משתנים שהמודול מקבל:
outputs.tf - ערכים שהמודול מחזיר:


תצורת השורש

main.tf - קובץ ראשי
הקובץ הזה קורא לכל המודולים אשר אני רוצה להפעיל 
VPC.EC2.S3

variables.tf - משתנים גלובליים
outputs.tf - פלטים גלובליים
terraform.tfvars - ערכים ספציפיים

לאחר שהכנתי את כל הקבצים האלו אני מתחיל הרצות.
קודם כל מתחילים בהתקנת TERRAFORM
לאחר מכן בודק גירסא על ידי הפקודה ב POWERSHELL
terraform version

לאחר מכן מתחיל את החיבור שלי עם AWS נותן את הפקודה ב POWERSHELL
aws configure
# הזן:
# - AWS Access Key ID
# - AWS Secret Access Key
# - region: us-east-1
לאחר מכן מתחיל הרצה של התכנית.
אני מוודא שאני נמצא בתקיה של התכנית ובמידה ולא אז מחפש ונכנס למיקום של התכנית.
מתחיל בפקודה של כניסה למערכת כלומר אתחול.
terraform init
לאחר הכניסה מוודא שהתכנית תקינה וללא תקלות על ידי הפקודה 
terraform plan
לאחר שהכל תקין וללא תקלות אני מפעיל את התוכנה על ידי הפקודה 
terraform apply -auto-approve
בעצם ההגדרה של הפקודה הזוז אני אמור לאפשר למערכת לא לבקש את אישורי אלא לאפשר הפעלה ללא עצירות 
לאחר שהכל עלה אני מוודא שהתהליך הצליח על ידי הפקודה 
terraform output
לארח שהכל תקין אני מפעיל את המערכת ונותן למערכת להפעיל את האתר על ידי הפקודה הבאה
Start-Process (terraform output -raw web_server_url)

אחרי שהכל תקין ועובד אני מבטל את התכנית ומוחק את מה שלא צריך בכדי שלא יתן לי חיובים מיותרים.
terraform destroy -auto-approve

לאחר ההרצה אקבל אישור שהכל נמחק.
