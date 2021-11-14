# 统计tp.txt文本中状态码出现次数；按照出现次数从大到小排序


1 root@archiso /yc # cat tp.txt

Not Found: /
HTTP GET / 404 [0.02, 192.168.117.1:55476]
Not Found: /favicon.ico
HTTP GET /favicon.ico 404 [0.01, 192.168.117.1:55476]
HTTP GET /api 301 [0.01, 192.168.117.1:55476]
Unauthorized: /api/
HTTP GET /api/ 401 [0.04, 192.168.117.1:55476]
HTTP GET /static/rest_framework/css/bootstrap.min.css 200 [0.02, 192.168.117.1:55476]
HTTP GET /static/rest_framework/css/bootstrap-tweaks.css 200 [0.02, 192.168.117.1:55477]
HTTP GET /static/rest_framework/css/prettify.css 200 [0.02, 192.168.117.1:55479]
HTTP GET /static/rest_framework/css/default.css 200 [0.02, 192.168.117.1:55480]
HTTP GET /static/rest_framework/js/jquery-3.4.1.min.js 200 [0.02, 192.168.117.1:55481]
HTTP GET /static/rest_framework/js/ajax-form.js 200 [0.02, 192.168.117.1:55482]
HTTP GET /static/rest_framework/js/bootstrap.min.js 200 [0.01, 192.168.117.1:55477]
HTTP GET /static/rest_framework/js/csrf.js 200 [0.02, 192.168.117.1:55476]
HTTP GET /static/rest_framework/js/prettify-min.js 200 [0.01, 192.168.117.1:55479]
HTTP GET /static/rest_framework/js/default.js 200 [0.02, 192.168.117.1:55480]
HTTP GET /static/rest_framework/img/grid.png 200 [0.00, 192.168.117.1:55480]
HTTP GET /api-auth/login/?next=/api/ 200 [0.02, 192.168.117.1:55480]
HTTP POST /api-auth/login/ 200 [0.10, 192.168.117.1:55480]
HTTP POST /api-auth/login/ 200 [0.10, 192.168.117.1:55480]
HTTP POST /api-auth/login/ 302 [0.10, 192.168.117.1:55480]
root@archiso /yc #

# tr -s '\n' 去掉空行
# uniq -c    统计出现的次数
# sort -nr   按照从大到小排序
root@archiso /yc # cat tp.txt|cut -d ' ' -f4|tr -s '\n'|uniq -c |sort -nr
     14 200
      2 404
      1 401
      1 302
      1 301
