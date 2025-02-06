#include <zephyr/kernel.h>
#include <zephyr/types.h>
#include <zephyr/bluetooth/bluetooth.h>
#include <zephyr/bluetooth/hci.h>
#include <zephyr/bluetooth/conn.h>
#include <zephyr/bluetooth/gap.h>
#include <zephyr/sys/printk.h>

void main(void)
{
    int err;
    printk("Starting BLE Peripheral... huehue\n");

    err = bt_enable(NULL);
    if (err) {
        printk("Bluetooth init failed (err %d)\n", err);
        return;
    }

    printk("Bluetooth initialized\n");

    const struct bt_le_adv_param *adv_param = BT_LE_ADV_CONN_NAME;
    
    err = bt_le_adv_start(adv_param, NULL, 0, NULL, 0);
    if (err) {
        printk("Advertising failed to start (err %d)\n", err);
        return;
    }

    printk("Advertising started\n");
}