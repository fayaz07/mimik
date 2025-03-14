import Input from "@mui/joy/Input";
import FormControl from "@mui/joy/FormControl";
import FormLabel from "@mui/joy/FormLabel";
import FormHelperText from "@mui/joy/FormHelperText";
import "./_.scss";

export { FormControl, FormLabel, FormHelperText, Input };

export interface TextFieldProps {
  value: string;
  onChange: (value: string) => void;
  label: string | null;
  placeholder: string | null;
  helperText: string | null;
  errorText: string | null;
}

TextField.defaultProps = {
  label: null,
  placeholder: "",
  helperText: null,
  errorText: null,
};

export default function TextField(props: TextFieldProps) {
  const { label, placeholder, helperText, errorText, value, onChange } = props;
  return (
    <FormControl className="appTF">
      {label && <FormLabel className="p-0 m-0">{label}</FormLabel>}

      <Input
        placeholder={placeholder?.toString()}
        value={value}
        onChange={(e) => {
          onChange(e.target.value);
        }}
      />
      {helperText && !errorText && (
        <FormHelperText className="appTF_helpTxt">{helperText}</FormHelperText>
      )}
      {errorText && (
        <FormHelperText className="appTF_errTxt">{errorText}</FormHelperText>
      )}
    </FormControl>
  );
}
