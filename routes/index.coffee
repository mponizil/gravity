exports.index = (req, res) ->
  res.render('index', title: "Collect it")

exports.signup = (req, res) ->
  res.render('signup')

exports.register = (req, res) ->
  username = email = req.body.email
  password = req.body.password
  req.app.kaiseki.createUser {username, email, password}, (error, response, user, success) ->
    req.login user, (error) ->
      res.redirect('/items')

exports.login = (req, res) ->
  res.render('login')

exports.logout = (req, res) ->
  req.logout()
  res.redirect('/')

exports.product = (req, res) ->
  OperationHelper = require('apac').OperationHelper

  opHelper = new OperationHelper
    awsId: req.app.config.AWS_ACCESS_KEY
    awsSecret: req.app.config.AWS_SECRET_ACCESS_KEY
    assocId: req.app.config.AWS_ASSOC_ID
  opHelper.execute 'ItemLookup',
    IdType: 'ASIN'
    ItemId: req.params.item_id
    ResponseGroup: 'ItemAttributes,Images'
  , (results) ->
    product =
      image: results.ItemLookupResponse.Items[0].Item[0].LargeImage[0].URL
      info: results.ItemLookupResponse.Items[0].Item[0].ItemAttributes[0].Title

    res.render('product', {product})

exports.search = (req, res) ->
  OperationHelper = require('apac').OperationHelper

  opHelper = new OperationHelper
    awsId: req.app.config.AWS_ACCESS_KEY
    awsSecret: req.app.config.AWS_SECRET_ACCESS_KEY
    assocId: req.app.config.AWS_ASSOC_ID
  opHelper.execute 'ItemSearch',
    ResponseGroup: 'ItemAttributes,Images'
    SearchIndex: 'All'
    Keywords: req.query.q
  , (results) ->
    page = parseInt(req.query.p ? 1, 10) - 1
    product =
      image: results.ItemSearchResponse.Items[0].Item[page].LargeImage[0].URL
      info: results.ItemSearchResponse.Items[0].Item[page].ItemAttributes[0].Title

    res.render('product', {product})

exports.items = require('./items')
