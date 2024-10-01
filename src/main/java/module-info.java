module in.mfayaz.mimik {
    requires javafx.controls;
    requires javafx.fxml;
    requires kotlin.stdlib;

    opens in.mfayaz.mimik to javafx.fxml;
    exports in.mfayaz.mimik;
}
