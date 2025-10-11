#!/usr/bin/env python3
"""
Test Python file for data science and development tooling validation.
This file tests various Python language server features.
"""

import pandas as pd
import numpy as np
from typing import List, Dict, Optional
import asyncio
import json
import yaml


class DataProcessor:
    """Example data processing class for testing LSP features."""

    def __init__(self, data_source: str):
        self.data_source = data_source
        self.df: Optional[pd.DataFrame] = None

    def load_data(self, file_path: str) -> pd.DataFrame:
        """Load data from various formats."""
        if file_path.endswith('.csv'):
            return pd.read_csv(file_path)
        elif file_path.endswith('.json'):
            return pd.read_json(file_path)
        elif file_path.endswith('.parquet'):
            return pd.read_parquet(file_path)
        else:
            raise ValueError(f"Unsupported file format: {file_path}")

    def process_data(self, operations: List[str]) -> Dict[str, float]:
        """Process data with various operations."""
        if self.df is None:
            raise ValueError("No data loaded")

        results = {}
        for op in operations:
            if op == 'mean':
                results[op] = self.df.mean().to_dict()
            elif op == 'std':
                results[op] = self.df.std().to_dict()
            elif op == 'count':
                results[op] = len(self.df)

        return results


async def async_data_pipeline(data_sources: List[str]) -> Dict:
    """Async data processing pipeline."""
    processors = [DataProcessor(source) for source in data_sources]

    tasks = []
    for processor in processors:
        # This would be async in real implementation
        task = asyncio.create_task(
            asyncio.sleep(0.1)  # Simulate async operation
        )
        tasks.append(task)

    await asyncio.gather(*tasks)

    return {
        'processed_sources': len(data_sources),
        'status': 'completed'
    }


def kubernetes_config_example():
    """Example of working with Kubernetes configs."""
    k8s_config = {
        'apiVersion': 'apps/v1',
        'kind': 'Deployment',
        'metadata': {
            'name': 'data-processor',
            'labels': {
                'app': 'data-processor'
            }
        },
        'spec': {
            'replicas': 3,
            'selector': {
                'matchLabels': {
                    'app': 'data-processor'
                }
            },
            'template': {
                'metadata': {
                    'labels': {
                        'app': 'data-processor'
                    }
                },
                'spec': {
                    'containers': [{
                        'name': 'processor',
                        'image': 'data-processor:latest',
                        'ports': [{
                            'containerPort': 8080
                        }]
                    }]
                }
            }
        }
    }

    return yaml.dump(k8s_config, default_flow_style=False)


if __name__ == '__main__':
    # Test basic functionality
    processor = DataProcessor('test_source')

    # Test async functionality
    loop = asyncio.get_event_loop()
    result = loop.run_until_complete(
        async_data_pipeline(['source1', 'source2'])
    )

    print(f"Pipeline result: {result}")
    print(kubernetes_config_example())