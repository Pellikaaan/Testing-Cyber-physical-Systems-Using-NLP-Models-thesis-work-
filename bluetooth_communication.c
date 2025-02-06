#include <zephyr.h>
#include <device.h>
#include <drivers/bluetooth/bluetooth.h>
#include <drivers/bluetooth/adv.h>

#define DEVICE_NAME "nRF5340_BLE"  // Name of the device

// Advertising data (you can customize this)
static struct bt_data ad[] = {
    BT_DATA_BYTES(BT_DATA_FLAGS, BT_FLAGS_LE_GENERAL | BT_FLAGS_BREDR_NOT_SUPPORTED),
    BT_DATA_BYTES(BT_DATA_NAME_COMPLETE, DEVICE_NAME)
};

// Function to start advertising
void start_advertising(void)
{
    int err;

    // Initialize Bluetooth
    err = bt_enable(NULL);
    if (err) {
        printk("Bluetooth init failed (err %d)\n", err);
        return;
    }

    // Start advertising
    err = bt_le_adv_start(BT_LE_ADV_PARAM_DEFAULT, ad, ARRAY_SIZE(ad), NULL, 0);
    if (err) {
        printk("Advertising failed to start (err %d)\n", err);
        return;
    }

    printk("Advertising started\n");
}

void main(void)
{
    printk("Starting BLE Advertising...\n");
    start_advertising();
}