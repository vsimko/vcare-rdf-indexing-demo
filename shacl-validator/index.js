#!/usr/bin/env node

const SHACLValidator = require("./shacl")

const validator = new SHACLValidator()

//console.log(validator)

// TODO: parse args
const data = ":a :b :c."
const shapes = ""

validator.validate(data, "text/turtle", shapes, "text/turtle", function (e, report) {
    console.log("Conforms? " + report.conforms());
    if (report.conforms() === false) {
        report.results().forEach(function(result) {
            console.log(" - Severity: " + result.severity() + " for " + result.sourceConstraintComponent());
        });
    }
})