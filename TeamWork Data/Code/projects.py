import urllib2, base64
 
company = "yat"
key = "twp_TEbBXGCnvl2HfvXWfkLUlzx92e3T"
action = "/projects/339988/tasklists.json"
 
request = urllib2.Request("https://{0}.teamwork.com/{1}".format(company, action))
request.add_header("Authorization", "BASIC " + base64.b64encode(key + ":xxx"))
 
response = urllib2.urlopen(request)
data = response.read()
 
print data
