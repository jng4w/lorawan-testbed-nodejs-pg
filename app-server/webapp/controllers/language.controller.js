exports.languageProcessing = async (req, res, next) => { 
    try {
        res.cookie('lang', req.params.lang, { maxAge: 900000 });
        res.redirect('back');
    } catch (error) {
        console.log(error);
    }
}



