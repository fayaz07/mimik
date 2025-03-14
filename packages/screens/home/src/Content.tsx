import React from "react";
import { whatPartOfTimeIsIt } from "@mimik/utils/src/Time";
import Stack from "@mimik/ui/src/components/stack";
import "./_.scss";

function Greeting() {
  return <h4>Hello, Good {whatPartOfTimeIsIt()}</h4>;
}

export default function Content() {
  return (
    <Stack>
      <Greeting />
    </Stack>
  );
}
