sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'logajog/product/test/integration/FirstJourney',
		'logajog/product/test/integration/pages/ProductsList',
		'logajog/product/test/integration/pages/ProductsObjectPage',
		'logajog/product/test/integration/pages/ReviewsObjectPage'
    ],
    function(JourneyRunner, opaJourney, ProductsList, ProductsObjectPage, ReviewsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('logajog/product') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheProductsList: ProductsList,
					onTheProductsObjectPage: ProductsObjectPage,
					onTheReviewsObjectPage: ReviewsObjectPage
                }
            },
            opaJourney.run
        );
    }
);