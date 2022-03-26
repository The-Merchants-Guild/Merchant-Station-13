import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';
import { Stack, Box, Divider, Flex, Grid, Input, NoticeBox, NumberInput } from '../components';

export const TargetGenesSection = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    target_genes,
  } = data;
  return (
    <Section fill title="Target Genes" scrollable>
      <LabeledList>
        {target_genes.map(gene_name => (
          <LabeledList.Item>
          <Button
            content={"Add "+ gene_name}
            onClick={() => act(gene_name)} />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  )
}

export const ConditionalGenesSection = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    conditional_genes,
  } = data;
  return (
    <Section fill title="Conditional Genes" scrollable>
      <LabeledList>
        {conditional_genes.map(gene_name => (
          <LabeledList.Item>
          <Button
            content={"Add "+ gene_name}
            onClick={() => act(gene_name)} />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  )
}

export const ProteinGenesSection = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    protein_genes,
  } = data;
  return (
    <Section fill title="Protein Genes" scrollable>
      <LabeledList>
        {protein_genes.map(gene_name => (
          <LabeledList.Item>
          <Button
            content={"Add "+ gene_name}
            onClick={() => act(gene_name)} />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  )
}

export const CurrentTargetsSection = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    crt_targets,
  } = data;
  return (
    <Section fill title="Current Targets" scrollable>
      <LabeledList>
        {crt_targets.map(gene_name => (
          <LabeledList.Item>
          <Button
            content={"Remove "+ gene_name}
            onClick={() => act("del_" + gene_name)} />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  )
}

export const CurrentCondSection = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    crt_conds,
  } = data;
  return (
    <Section fill title="Current Conditionals" scrollable>
      <LabeledList>
        {crt_conds.map(gene_name => (
          <LabeledList.Item>
          <Button
            content={"Remove "+ gene_name}
            onClick={() => act("del_" + gene_name)} />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  )
}

export const CurrentProtSection = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    crt_prot,
  } = data;
  return (
    <Section fill title="Current Proteins" scrollable>
      <LabeledList>
        {crt_prot.map(gene_name => (
          <LabeledList.Item>
          <Button
            content={"Remove "+ gene_name}
            onClick={() => act("del_" + gene_name)} />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  )
}

export const GeneInterface = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const {
    target_genes,
    conditional_genes,
    protein_genes,
    crt_targets,
    crt_conds,
    crt_prot
  } = data;
  return (
    <Window resizable
      width={1200}
      height={800}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item width="33%">
                <TargetGenesSection/>
              </Stack.Item>
              <Stack.Item width="33%">
                <ConditionalGenesSection/>
              </Stack.Item>
              <Stack.Item width="33%">
                <ProteinGenesSection/>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack height="300px">
            <Stack.Item width="33%">
              <CurrentTargetsSection/>
            </Stack.Item>
            <Stack.Item width="33%">
              <CurrentCondSection/>
            </Stack.Item>
            <Stack.Item width="33%">
              <CurrentProtSection/>
            </Stack.Item>
            <Button
              content={"Print  "}
              onClick={() => act("print")} />
          </Stack>
        </Stack>
      </Window.Content>
    </Window>
  );
};
