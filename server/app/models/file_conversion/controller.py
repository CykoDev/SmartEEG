from flask import Blueprint, request, render_template, flash, g, session, redirect, url_for


file_conversion_controller = Blueprint('conversion', __name__, url_prefix='/conversion')

@file_conversion_controller.route('/test/', methods=['GET'])
def test():
    return "test123"