import { extend, localize, setInteractionMode } from "vee-validate";
import ja from "vee-validate/dist/locale/ja.json";
import {
  email,
  ext,
  integer,
  max,
  min,
  regex,
  required,
  size,
} from "vee-validate/dist/rules";

extend("email", email);
extend("ext", ext);
extend("integer", {
  ...integer,
  message: "半角数字で入力してください",
});
extend("max", max);
extend("min", min);
extend("regex", regex);
extend("required", required);
extend("size", size);

localize("ja", ja);

setInteractionMode("eager");

const VeeValidate = { extend, localize, setInteractionMode };

export default VeeValidate;
