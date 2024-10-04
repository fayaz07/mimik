module in.mfayaz.mimik.core {
    requires javafx.controls;
    requires javafx.fxml;
    requires kotlin.stdlib;


    opens in.mfayaz.mimik.core to javafx.fxml;
    exports in.mfayaz.mimik.core;
}