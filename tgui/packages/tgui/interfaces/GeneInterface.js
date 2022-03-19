import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const GeneInterface = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const {
    gene,
  } = data;
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Current Gene">
          <LabeledList>
            {target_genes.map(gene_name => (
              <LabeledList.Item label="{gene_name}">
              <Button
                content="Add this gene frame to the gene"
                onClick={() => act('{gene_name}')} />
              </LabeledList.Item>
            ))}
            <LabeledList.Item label="Target Organs">
              Test
            </LabeledList.Item>
            <LabeledList.Item label="Conditions">
              Test
            </LabeledList.Item>
            <LabeledList.Item label="Proteins">
              Test
            </LabeledList.Item>
            <LabeledList.Item label="Button">
              <Button
                content="Dispatch a 'test' action"
                onClick={() => act('test')} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
