const Index = require('../models/index.model');
const {validationResult } = require('express-validator');

exports.registerProcessing = async (req, res, next) => {
    const errors = validationResult(req);

    if (!errors.isEmpty()) {
        
        return res.status(400).json({
            success: false,
            errors: errors.array()
        });
    }

    res.status(200).json({
        success: true,
        message: 'Login successful',
    })
}





