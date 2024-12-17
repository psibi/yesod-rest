GET http://localhost:9000
HTTP 200

GET http://localhost:9000/api/v1/user
HTTP 200
[Asserts]
status == 200
jsonpath "$.name" contains "Sibi"
