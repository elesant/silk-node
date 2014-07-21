exports.post = function (req, res) {
  var message = req.body.message;
  res.json(message);
};
