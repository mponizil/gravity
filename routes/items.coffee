passport = require('passport')

exports.index = (req, res) ->
  params =
    where:
      collector:
        __type: 'Pointer'
        className: '_User'
        objectId: req.user.objectId

  req.app.kaiseki.getObjects 'Item', params, (error, response, items, success) ->
    res.render('items/index', {items})

exports.new = (req, res) ->
  item =
    title: req.query.title or "N/A"
    image: req.query.image or "http://placehold.it/400x300"
    price: req.query.price or 0
    hostname: req.query.hostname or "N/A"
    url: req.query.url or "N/A"

  res.render('items/new', {item})

exports.create = (req, res) ->
  item =
    collector:
      __type: 'Pointer'
      className: '_User'
      objectId: req.user.objectId
    title: req.body.title or "N/A"
    image: req.body.image or "http://placehold.it/400x300"
    price: parseFloat(req.body.price) or 0
    hostname: req.body.hostname or "N/A"
    url: req.body.url or "N/A"

  req.app.kaiseki.createObject 'Item', item, (error, response, body, success) ->
    res.redirect('/items')

exports.destroy = (req, res) ->
  req.app.kaiseki.deleteObject 'Item', req.params.id, (error, response, body, success) ->
    if error
      res.json(error)
    else
      res.json(200)
