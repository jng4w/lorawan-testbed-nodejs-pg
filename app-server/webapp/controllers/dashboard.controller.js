const Index = require('../models/index.model');

exports.dashboardProcessing = async (req, res, next) => {
    
    if(req.session.login){
        // console.log((await Index.selectBoardWidgetFromCustomer(req.session.user.id)).rows);
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





