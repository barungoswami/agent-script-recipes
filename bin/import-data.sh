#!/bin/bash
# Import data for Agent Recipes

echo "Assigning permission sets..."
sf org assign permset -n Agent_Script_Recipes

echo "Importing standard setup data..."
sf data import tree --files data/standard-setup.json

echo "Importing commerce account data..."
sf data import tree --files data/commerce-account.json

echo "Importing commerce product data..."
sf data import tree --files data/commerce-product.json

echo "Importing commerce cart data..."
sf data import tree --files data/commerce-cart.json

echo "Importing travel hotel data..."
sf data import tree --files data/travel-hotel.json

echo "Importing travel itinerary data..."
sf data import tree --files data/travel-itinerary.json

echo "Importing financial account data..."
sf data import tree --files data/financial-account.json

echo "Importing financial payment data..."
sf data import tree --files data/financial-payment.json

echo "Importing service case data..."
sf data import tree --files data/service-case.json

echo "Importing service event data..."
sf data import tree --files data/service-event.json

echo "Importing general task data..."
sf data import tree --files data/general-task.json

echo "Importing general report data..."
sf data import tree --files data/general-report.json

echo "Importing general onboarding data..."
sf data import tree --files data/general-onboarding.json

echo "Importing general survey data..."
sf data import tree --files data/general-survey.json

echo "Data import complete."

