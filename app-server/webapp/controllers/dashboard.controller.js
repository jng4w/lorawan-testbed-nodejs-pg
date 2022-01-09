const Index = require('../models/index.model');

exports.dashboardProcessing = async (req, res, next) => {
    
    
    if(req.session.login){
        // console.log((await Index.selectBoardWidgetFromCustomer(req.session.user.id)).rows);
        // console.log(req);
        // console.log(req.sessionStore._events.disconnect);
        res.render('main/dashboard', {
            devices: 1,
            user: req.session.user,
            boardWidget: (await Index.selectBoardWidgetFromCustomer(req.session.user.id)).rows

        });
    }
    else {
        res.redirect('login');
    }
    
    
    

}





