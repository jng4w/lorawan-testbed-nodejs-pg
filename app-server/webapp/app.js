// const createError = require('http-errors');
const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const bodyParser = require('body-parser');
const session = require('express-session');
const i18n = require("i18n");

const indexRouter = require('./routes/index.route');
const dashboardRouter = require('./routes/dashboard.route');
const loginRouter = require('./routes/login.route');
const registerRouter = require('./routes/register.route');
const userRouter = require('./routes/user.route');
const deviceRouter = require('./routes/device.route');
const settingRouter = require('./routes/setting.route');
const logoutRouter = require('./routes/logout.route');
const languageRouter = require('./routes/language.route');

// var usersRouter = require('./routes/users');
// var diaryRouter = require('./routes/diary.route');

const app = express();

// view engine setup
app.use(express.static('public'))
app.use('/css',express.static(__dirname + 'public/css'))
app.use('/scss',express.static(__dirname + 'public/scss'))
app.use('/img',express.static(__dirname + 'public/img'))
app.use('/js',express.static(__dirname + 'public/js'))
app.use('/vendor', express.static(__dirname + 'public/vendor'))

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use(session({
	secret: 'secret',
	resave: true,
	saveUninitialized: true,
  rolling: true,
  cookie: {
 
    // Session expires after a time of inactivity.
    
    // maxAge: 10000
}
}));

// language node package
app.use(i18n.init);

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use('/', indexRouter);
app.use('/dashboard', dashboardRouter);
app.use('/login', loginRouter);
app.use('/register', registerRouter);
app.use('/user', userRouter);
app.use('/device', deviceRouter);
app.use('/setting', settingRouter);
app.use('/logout', logoutRouter);
app.use('/change-lang', languageRouter);

// app.use('/', indexRouter);
// app.use('/users', usersRouter);
// app.use('/diary/', diaryRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

i18n.configure({
  locales:['en', 'vi'],
  directory: __dirname + '/locales',
  cookie: 'lang',
 });

module.exports = app;
