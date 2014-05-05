$ ->

  queryStr = location.search.substring(1)
  params = queryStr.split('&')
  query = {}
  for param in params
    [key, value] = param.split('=')
    query[key] = value

  $(window).keyup (e) ->
    console.log e.which
    if e.which is 39 # right
      location.href = location.href.replace /p=(\d+)/, (match, page) -> "p=#{parseInt(page, 10) + 1}"
    else if e.which is 37
      location.href = location.href.replace /p=(\d+)/, (match, page) -> "p=#{parseInt(page, 10) - 1}" if page > 1
