#include <winrt/Windows.ApplicationModel.Store.h>
#include <iostream>

using namespace winrt;
using namespace Windows::ApplicationModel::Store;

StoreContext context = nullptr;
StoreProduct subscriptionStoreProduct;

// Assign this variable to the Store ID of your subscription add-on.
std::wstring subscriptionStoreId = L"";

// This is the entry point method for the example.
IAsyncAction SetupSubscriptionInfoAsync()
{
    if (context == nullptr)
    {
        context = co_await StoreContext::GetDefaultAsync();
        // If your app is a desktop app that uses the Desktop Bridge, you
        // may need additional code to configure the StoreContext object.
        // For more info, see https://aka.ms/storecontext-for-desktop.
    }

    bool userOwnsSubscription = co_await CheckIfUserHasSubscriptionAsync();
    if (userOwnsSubscription)
    {
        // Unlock all the subscription add-on features here.
        co_return;
    }

    // Get the StoreProduct that represents the subscription add-on.
    subscriptionStoreProduct = co_await GetSubscriptionProductAsync();
    if (subscriptionStoreProduct == nullptr)
    {
        co_return;
    }

    // Check if the first SKU is a trial and notify the customer that a trial is available.
    // If a trial is available, the Skus array will always have 2 purchasable SKUs and the
    // first one is the trial. Otherwise, this array will only have one SKU.
    StoreSku sku = subscriptionStoreProduct.Skus().GetAt(0);
    if (sku.SubscriptionInfo().HasTrialPeriod())
    {
        // You can display the subscription trial info to the customer here. You can use 
        // sku.SubscriptionInfo().TrialPeriod() and sku.SubscriptionInfo().TrialPeriodUnit()
        // to get the trial details.
    }
    else
    {
        // You can display the subscription purchase info to the customer here. You can use 
        // sku.SubscriptionInfo().BillingPeriod() and sku.SubscriptionInfo().BillingPeriodUnit()
        // to provide the renewal details.
    }

    // Prompt the customer to purchase the subscription.
    co_await PromptUserToPurchaseAsync();
}

IAsyncOperation<bool> CheckIfUserHasSubscriptionAsync()
{
    StoreAppLicense appLicense = co_await context.GetAppLicenseAsync();

    // Check if the customer has the rights to the subscription.
    for (auto const& addOnLicense : appLicense.AddOnLicenses())
    {
        StoreLicense license = addOnLicense.Value();
        if (license.SkuStoreId().starts_with(subscriptionStoreId))
        {
            if (license.IsActive())
            {
                // The expiration date is available in the license.ExpirationDate() property.
                co_return true;
            }
        }
    }

    // The customer does not have a license to the subscription.
    co_return false;
}

IAsyncOperation<StoreProduct> GetSubscriptionProductAsync()
{
    // Load the sellable add-ons for this app and check if the trial is still 
    // available for this customer. If they previously acquired a trial, they won't 
    // be able to get a trial again, and the StoreProduct.Skus property will 
    // only contain one SKU.
    StoreProductQueryResult result = co_await context.GetAssociatedStoreProductsAsync({ L"Durable" });

    if (result.ExtendedError() != nullptr)
    {
        std::wcout << L"Something went wrong while getting the add-ons. ExtendedError: " << result.ExtendedError().Message().c_str() << std::endl;
        co_return nullptr;
    }

    // Look for the product that represents the subscription.
    for (auto const& item : result.Products())
    {
        StoreProduct product = item.Value();
        if (product.StoreId() == subscriptionStoreId)
        {
            co_return product;
        }
    }

    std::wcout << L"The subscription was not found." << std::endl;
    co_return nullptr;
}

IAsyncAction PromptUserToPurchaseAsync()
{
    // Request a purchase of the subscription product. If a trial is available, it will be offered 
    // to the customer. Otherwise, the non-trial SKU will be offered.
    StorePurchaseResult result = co_await subscriptionStoreProduct.RequestPurchaseAsync();

    // Capture the error message for the operation, if any.
    std::wstring extendedError;
    if (result.ExtendedError() != nullptr)
    {
        extendedError = result.ExtendedError().Message().c_str();
    }

    switch (result.Status())
    {
    case StorePurchaseStatus::Succeeded:
        // Show a UI to acknowledge that the customer has purchased your subscription 
        // and unlock the features of the subscription.
        break;

    case StorePurchaseStatus::NotPurchased:
        std::wcout << L"The purchase did not complete. The customer may have cancelled the purchase. ExtendedError: " << extendedError.c_str() << std::endl;
        break;

    case StorePurchaseStatus::ServerError:
    case StorePurchaseStatus::NetworkError:
        std::wcout << L"The purchase was unsuccessful due to a server or network error. ExtendedError: " << extendedError.c_str() << std::endl;
        break;

    case StorePurchaseStatus::AlreadyPurchased:
        std::wcout << L"The customer already owns this subscription. ExtendedError: " << extendedError.c_str() << std::endl;
        break;
    }
}
