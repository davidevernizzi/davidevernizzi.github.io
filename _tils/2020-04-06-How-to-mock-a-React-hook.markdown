---
layout: post
title:  "How to mock a React hook"
date:   2020-04-06
tags: []
---

To mock a React hook (in this example `useState`):

```javascript
import React, { useState, setState } from "react";
import { render } from "@testing-library/react";
import Foo from "../";

jest.mock('react', () => ({
  ...jest.requireActual('react'), // Important to make the rest of React working
  useState: jest.fn(),
}));

beforeEach(() => {
  useState.mockImplementation(init => [init, setState]); // Actual mock. Uses setState from React and returns init value
});

test('foo test', () => {
  // Overwrite the mock defined earlier, by always returning 'foobar'
  useState.mockImplementation(init => ['fobar', setState]);
  const { queryByText } = render(<Foo />);

  expect(queryByText(/foobar/i)).toBe(true);
});

```
